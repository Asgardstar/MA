# multi_agent_system.py
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
    # mcp_results: Dict[str, Any] = {} 
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
    # This input is now more generic
    task: str = Field(description="A natural language description of the simulation, code generation, or external task to be executed.")


class FormatInput(BaseModel):
    content: str = Field(description="The content to format")


class LangGraphMultiAgentSystem:
    def __init__(self):
        self.feedback = LiveFeedback()
        # Initialize agents with proper names
        self.search_agent = SearchAgent()
        self.simulation_agent = SimulationAgent() # The new, unified agent
        # self.mcp_agent = MCPAgent() # This is no longer needed

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
                Use this tool when you need to find information within the system's knowledge base.
                It can search for requirements, functions, solutions, products, and models.
                Input should be a natural language query about what to search for.
                """,
                args_schema=SearchInput
            ),
            StructuredTool.from_function(
                func=self._simulation_agent_tool,
                name="execute_external_task", # Renamed for clarity
                description="""
                Use this tool for any task that requires external computation or interaction with a model.
                This includes running simulations (like battery or motor models) and generating or executing new code (like MATLAB scripts).
                Input should be a detailed, natural language description of the task.
                """,
                args_schema=SimulationInput
            ),

            StructuredTool.from_function(
                func=self._format_answer_tool,
                name="format_final_answer",
                description="""
                Use this tool as the final step when you have gathered all necessary information 
                and need to present the complete response to the user.
                Input should be the raw answer content to be formatted.
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
        """
        Tool wrapper for the new, unified simulation agent.
        It now handles all external tasks via MCP.
        """
        self.feedback.send("⚙️ Processing external task request...")

        try:
            # Create state for simulation agent
            sim_state = {
                "query": task,
                "messages": [],
                "search_results": getattr(self.feedback, 'search_results', {})  # Pass along any prior search results
            }

            # Run simulation agent
            result = self.simulation_agent.process(sim_state)

            # Extract results
            simulation_results = result.get("simulation_results", {})

            if simulation_results and simulation_results.get("summary"):
                self.feedback.send("✨ External task completed successfully")
                logger.info(f"Simulation/MCP results: {simulation_results}")

                # Store results in feedback system
                self.feedback.simulation_results = simulation_results

                # Return a structured response
                return f"Task completed. Result: {simulation_results.get('summary')}"
            elif result.get("error"):
                 raise Exception(result.get("error"))
            else:
                self.feedback.send("📋 Task finished, but returned no summary.")
                return "Task completed without a summary."

        except Exception as e:
            logger.error(f"Error in simulation/external task tool: {str(e)}")
            self.feedback.send(f"❌ Task error: {str(e)}", level="error")
            return f"Error running external task: {str(e)}"
    

    def _format_answer_tool(self, content: str):
        """Tool wrapper for formatting final answer"""
        self.feedback.send("✅ Formatting final response...")

        # Get all results from feedback system
        search_results = getattr(self.feedback, 'search_results', {})
        sim_results = getattr(self.feedback, 'simulation_results', {})

        try:
            if content.startswith("{") or content.startswith("["):
                content_data = json.loads(content)
                if isinstance(content_data, dict):
                    if "findings" in content_data:
                        search_results = content_data
                    elif "search_results" in content_data:
                        search_results = content_data["search_results"]
                    content = content_data.get("summary", content_data.get("message", str(content_data)))
        except json.JSONDecodeError:
            pass

        # Create formatted answer
        formatted = self._create_formatted_answer(content, search_results, sim_results)

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

        # Updated to check for the summary from the new unified agent
        if sim_results and sim_results.get("summary"):
            sections.append("\n## ⚙️ External Task Results\n")
            sections.append(sim_results['summary'])

        return "\n".join(sections)

    def _create_supervisor(self):
        """Create supervisor using ReAct agent"""
        llm = get_llm("supervisor")

        # Create ReAct agent with system prompt
        return create_react_agent(
            model=llm,
            tools=self.tools,
            prompt=LANGGRAPH_SUPERVISOR_PROMPT
        )

    def run(self, messages: List[Dict[str, Any]], session_id: str = None) -> Dict[str, Any]:
        """Run the multi-agent system using LangGraph"""
        if not session_id:
            session_id = get_session_id()

        # Convert the message history from dicts to LangChain message objects
        langchain_messages = []
        for msg in messages:
            if msg.get("role") == "user":
                langchain_messages.append(HumanMessage(content=msg.get("content")))
            elif msg.get("role") == "assistant":
                langchain_messages.append(AIMessage(content=msg.get("content")))
        
        # Use the latest user query from the history
        query = langchain_messages[-1].content if langchain_messages else ""

        # Initialize state with the full message history
        initial_state = {
            "messages": langchain_messages,
            "query": query,
            "session_id": session_id,
        }

        try:
            self.feedback.send(f"🚀 Processing query: {query}")

            # Clear previous results from feedback system
            for attr in ['search_results', 'simulation_results', 'formatted_answer']:
                if hasattr(self.feedback, attr):
                    delattr(self.feedback, attr)

            # Run supervisor with ReAct agent
            result = self.supervisor.invoke(initial_state)

            # Extract final answer
            final_answer_obj = result.get("messages", [])[-1]
            final_response = final_answer_obj.content if final_answer_obj else "I couldn't generate a response."

            # Use the formatted answer if available
            final_response = getattr(self.feedback, 'formatted_answer', final_response)
            
            return {
                "response": final_response,
                "feedback": self.feedback.get_all(),
                "search_results": getattr(self.feedback, 'search_results', {}),
                "simulation_results": getattr(self.feedback, 'simulation_results', {}),
                # "mcp_results": getattr(self.feedback, 'mcp_results', {}), # Deprecated
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