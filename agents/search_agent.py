from typing import Dict, Any
from langchain.agents import AgentExecutor, create_react_agent
from langchain_core.messages import AIMessage
from models.llm import get_llm
from tools.graph_search.semantic_cypher import semantic_cypher_search
from prompts.search_agent_prompt import SEARCH_AGENT_PROMPT
from langchain.tools import Tool
import logging

logger = logging.getLogger(__name__)


class SearchAgent:
    def __init__(self):
        # Initialize LLM specifically for search agent
        self.llm = get_llm("searchagent")
        self.tools = self._create_tools()
        self.agent = self._create_agent()
        self.agent_executor = self._create_executor()


    def _create_tools(self):
        """Create tools for the search agent"""
        # Create the semantic cypher search tool
        semantic_tool = Tool(
            name="semantic_cypher_search",
            func=semantic_cypher_search,
            description="""
            Search the knowledge graph using semantic search followed by Cypher queries.
            This tool first performs semantic search to find relevant nodes, then generates
            a Cypher query to retrieve detailed information. Use this for any queries about:
            - Requirements (functional, design, performance, resource)
            - Functions and their relationships
            - Solutions and their properties
            - Products and their attributes
            - Models and simulations
            Input should be a natural language query.
            """
        )

        return [semantic_tool]

    def _create_agent(self):
        """Create the search agent"""
        return create_react_agent(
            llm=self.llm,
            tools=self.tools,
            prompt=SEARCH_AGENT_PROMPT
        )

    def _create_executor(self):
        """Create the agent executor"""
        return AgentExecutor(
            agent=self.agent,
            tools=self.tools,
            verbose=True,
            handle_parsing_errors=True,
            max_iterations=5,
            return_intermediate_steps=True
        )

    def process(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Process the search request"""
        query = state.get("query", "")

        try:
            # Run the agent
            result = self.agent_executor.invoke({
                "input": query,
                "chat_history": state.get("messages", [])
            })

            # Extract results
            output = result.get("output", "")
            intermediate_steps = result.get("intermediate_steps", [])

            # Parse the results
            search_results = self._parse_search_results(output, intermediate_steps)

            # Update state
            state["search_results"] = search_results
            state["messages"].append(AIMessage(content=f"Search Agent: {output}"))

            # Add intermediate steps for feedback
            if intermediate_steps:
                state.setdefault("intermediate_steps", []).extend(intermediate_steps)

            logger.info(f"Search agent completed with {len(search_results)} results")

            return state

        except Exception as e:
            logger.error(f"Error in search agent: {str(e)}")
            state["error"] = f"Search error: {str(e)}"
            return state

    def _parse_search_results(self, output: str, intermediate_steps: list) -> Dict[str, Any]:
        """Parse search results from the agent output"""
        results = {
            "raw_output": output,
            "findings": [],
            "summary": ""
        }

        # Extract findings from intermediate steps
        for step in intermediate_steps:
            if isinstance(step, tuple) and len(step) == 2:
                action, observation = step
                if action.tool == "semantic_cypher_search":
                    results["findings"].append({
                        "query": action.tool_input,
                        "result": observation
                    })

        # Extract summary from output
        if "summary:" in output.lower():
            summary_start = output.lower().find("summary:") + 8
            results["summary"] = output[summary_start:].strip()
        else:
            results["summary"] = output.strip()

        return results