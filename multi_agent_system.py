from typing import Annotated, Dict, Any, List, Literal
from langgraph.prebuilt import InjectedState, create_react_agent
from langgraph.graph import StateGraph, MessagesState
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain.tools import Tool, StructuredTool
from prompts.supervisor_prompt import LANGGRAPH_SUPERVISOR_PROMPT
from pydantic import BaseModel, Field
import logging
import json

from models.llm import get_llm
from agents.search_agent import SearchAgent
from agents.simulation_agent import SimulationAgent
from tools.live_feedback import LiveFeedback
from utils.utils import get_session_id

logger = logging.getLogger(__name__)


class AgentState(MessagesState):
    """Extended state to include our specific fields"""
    query: str
    search_results: Dict[str, Any] = {}
    simulation_results: Dict[str, Any] = {}
    final_answer: str = ""
    formatted_answer: str = ""
    feedback: List[Dict[str, Any]] = []
    error: str = ""
    session_id: str = ""
    intermediate_steps: List[Any] = []


# Define input models for tools
class SearchInput(BaseModel):
    query: str = Field(description="The search query")


class SimulationInput(BaseModel):
    task: str = Field(description="The simulation task description")


class FormatInput(BaseModel):
    content: str = Field(description="The content to format")


class LangGraphMultiAgentSystem:
    def __init__(self):
        self.feedback = LiveFeedback()
        # Initialize agents with proper names
        self.search_agent = SearchAgent()
        self.simulation_agent = SimulationAgent()

        # Create tools from agents
        self.tools = self._create_tools()

        # Create supervisor using ReAct agent
        self.supervisor = self._create_supervisor()

    def _create_tools(self) -> List[Tool]:
        """Create tools from our agents that the supervisor can call"""
        # Using structured tools for better parameter handling
        return [
            StructuredTool.from_function(
                func=self._search_agent_tool,
                name="search_knowledge_graph",
                description="""
                Search the knowledge graph for information about requirements, functions, 
                solutions, products, and models. Use this when you need to find information
                in the system's knowledge base.
                Input: natural language query about what to search for.
                """,
                args_schema=SearchInput
            ),
            StructuredTool.from_function(
                func=self._simulation_agent_tool,
                name="run_simulation",
                description="""
                Run simulations using available models in the knowledge graph.
                Use this for simulation-related tasks like accessing models,
                executing simulations, or analyzing simulation results.
                Input: description of the simulation task needed.
                """,
                args_schema=SimulationInput
            ),
            StructuredTool.from_function(
                func=self._format_answer_tool,
                name="format_final_answer",
                description="""
                Format the final answer in a user-friendly way using all collected information.
                Use this when you have gathered all necessary information and need to present
                the final response to the user.
                Input: raw answer content to format.
                """,
                args_schema=FormatInput
            )
        ]

    def _search_agent_tool(self, query: str):
        """Tool wrapper for search agent"""
        self.feedback.send("🔍 Searching knowledge graph...")

        try:
            # Create state for search agent
            search_state = {
                "query": query,
                "messages": []
            }

            # Run search agent
            result = self.search_agent.process(search_state)

            # Extract results
            search_results = result.get("search_results", {})

            # Make sure to return a clear indication of what was found
            if search_results and search_results.get("findings"):
                self.feedback.send(f"📊 Found {len(search_results['findings'])} results")
                logger.info(f"Search results: {search_results}")

                # Store results in the shared feedback system to pass them along
                self.feedback.search_results = search_results

                # Return a structured response
                return f"Found {len(search_results['findings'])} results: {json.dumps(search_results, indent=2)}"
            else:
                self.feedback.send("ℹ️ No relevant information found")
                return "No relevant information found in the knowledge graph."

        except Exception as e:
            logger.error(f"Error in search tool: {str(e)}")
            self.feedback.send(f"❌ Search error: {str(e)}", level="error")
            return f"Error searching knowledge graph: {str(e)}"

    def _simulation_agent_tool(self, task: str):
        """Tool wrapper for simulation agent"""
        self.feedback.send("⚙️ Processing simulation request...")

        try:
            # Create state for simulation agent
            sim_state = {
                "query": task,
                "messages": [],
                "search_results": getattr(self.feedback, 'search_results', {})  # Get previously stored results
            }

            # Run simulation agent
            result = self.simulation_agent.process(sim_state)

            # Extract results
            simulation_results = result.get("simulation_results", {})

            if simulation_results:
                self.feedback.send("✨ Simulation completed successfully")
                logger.info(f"Simulation results: {simulation_results}")

                # Store results in feedback system
                self.feedback.simulation_results = simulation_results

                # Return a structured response
                return f"Simulation completed: {json.dumps(simulation_results, indent=2)}"
            else:
                self.feedback.send("📋 Simulation analysis completed")
                return "Simulation analysis completed without results."

        except Exception as e:
            logger.error(f"Error in simulation tool: {str(e)}")
            self.feedback.send(f"❌ Simulation error: {str(e)}", level="error")
            return f"Error running simulation: {str(e)}"

    def _format_answer_tool(self, content: str):
        """Tool wrapper for formatting final answer"""
        self.feedback.send("✅ Formatting final response...")

        # Get all results from feedback system
        search_results = getattr(self.feedback, 'search_results', {})
        sim_results = getattr(self.feedback, 'simulation_results', {})

        # Parse content if it's a JSON string
        try:
            if content.startswith("{") or content.startswith("["):
                content_data = json.loads(content)
                if isinstance(content_data, dict):
                    # Extract search results if they're in the content
                    if "findings" in content_data:
                        search_results = content_data
                    elif "search_results" in content_data:
                        search_results = content_data["search_results"]
                    content = content_data.get("summary", content_data.get("message", str(content_data)))
        except json.JSONDecodeError:
            pass

        # Create formatted answer
        formatted = self._create_formatted_answer(content, search_results, sim_results)

        # Store the formatted answer in feedback system
        self.feedback.formatted_answer = formatted

        return formatted

    def _create_formatted_answer(self, content: str, search_results: Dict, sim_results: Dict) -> str:
        """Create a well-formatted answer"""
        sections = []

        if content:
            sections.append(content)

        if search_results and search_results.get("findings"):
            sections.append("\n## 🔍 Knowledge Graph Findings\n")
            for finding in search_results["findings"]:
                sections.append(f"- **Query**: {finding.get('query', '')}")
                sections.append(f"  **Result**: {finding.get('result', '')}")
                sections.append("")  # Add empty line for spacing

        if sim_results and sim_results.get("executions"):
            sections.append("\n## ⚙️ Simulation Results\n")
            for execution in sim_results["executions"]:
                sections.append(f"- **Type**: {execution.get('type', '')}")
                sections.append(f"  **Result**: {execution.get('result', '')}")
                sections.append("")  # Add empty line for spacing

        return "\n".join(sections)

    def _create_supervisor(self):
        """Create supervisor using ReAct agent"""
        llm = get_llm("supervisor")

        # Create ReAct agent with system prompt
        return create_react_agent(
            model=llm,
            tools=self.tools,
            state_modifier=LANGGRAPH_SUPERVISOR_PROMPT
        )

    def run(self, query: str, session_id: str = None) -> Dict[str, Any]:
        """Run the multi-agent system using LangGraph"""
        if not session_id:
            session_id = get_session_id()

        # Initialize state - notice we now use a simple dictionary
        initial_state = {
            "messages": [HumanMessage(content=query)],
            "query": query,
            "session_id": session_id,
            "search_results": {},
            "simulation_results": {},
            "formatted_answer": "",
            "feedback": [],
            "intermediate_steps": []
        }

        try:
            self.feedback.send(f"🚀 Processing query: {query}")

            # Clear previous results from feedback system
            if hasattr(self.feedback, 'search_results'):
                delattr(self.feedback, 'search_results')
            if hasattr(self.feedback, 'simulation_results'):
                delattr(self.feedback, 'simulation_results')
            if hasattr(self.feedback, 'formatted_answer'):
                delattr(self.feedback, 'formatted_answer')

            # Run supervisor with ReAct agent
            result = self.supervisor.invoke(initial_state)

            # Extract final answer
            final_response = getattr(self.feedback, 'formatted_answer', "")

            if not final_response:
                # Try to extract from messages if formatted_answer not set
                for msg in reversed(result.get("messages", [])):
                    if isinstance(msg, AIMessage):
                        final_response = msg.content
                        break

            if not final_response:
                final_response = "I couldn't generate a response. Please try rephrasing your question."

            # Get the stored results
            search_results = getattr(self.feedback, 'search_results', {})
            simulation_results = getattr(self.feedback, 'simulation_results', {})

            return {
                "response": final_response,
                "feedback": self.feedback.get_all(),
                "search_results": search_results,
                "simulation_results": simulation_results,
                "error": None
            }

        except Exception as e:
            logger.error(f"Error in multi-agent system: {str(e)}")
            return {
                "response": self._format_error_message(str(e)),
                "feedback": self.feedback.get_all(),
                "error": str(e)
            }

    def _format_error_message(self, error: str) -> str:
        """Format error messages for users"""
        return f"""
## ❌ Error Occurred

I encountered an error while processing your request:

```
{error}
```

**What you can do:**
1. Try rephrasing your question
2. Provide more specific details
3. Check if all required information is available

If the problem persists, please contact support.
"""


# Factory function
def create_langgraph_multi_agent_system() -> LangGraphMultiAgentSystem:
    """Create and return a LangGraph-based multi-agent system"""
    return LangGraphMultiAgentSystem()