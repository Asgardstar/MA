# agents/mcp_agent.py
from typing import Dict, Any, List
from langchain.agents import AgentExecutor, create_react_agent
from models.llm import get_llm
from prompts.mcp_agent_prompt import MCP_AGENT_PROMPT 
from tools.tool_registry import tool_registry 
import logging

logger = logging.getLogger(__name__)

class MCPAgent:
    def __init__(self):
        logger.info("Initializing MCPAgent...")
        self.llm = get_llm("mcpagent")
        
        # Get tools dynamically from the registry
        self.tools = tool_registry.get_tools()
        if not self.tools:
            raise RuntimeError("MCP Agent initialized, but no tools were discovered from MCP servers.")
            
        self.agent = self._create_agent()
        self.agent_executor = self._create_executor()

    def _create_agent(self):
        """Create the ReAct agent that can plan and execute."""
        return create_react_agent(
            llm=self.llm,
            tools=self.tools,
            prompt=MCP_AGENT_PROMPT 
        )

    def _create_executor(self):
        """Create the agent executor."""
        return AgentExecutor(
            agent=self.agent,
            tools=self.tools,
            verbose=True,
            handle_parsing_errors=True,
            max_iterations=10,  
            return_intermediate_steps=True
        )

    def process(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Process the request by invoking the agent executor."""
        query = state.get("query", "")
        logger.info(f"MCPAgent processing query: {query}")

        try:
            result = self.agent_executor.invoke({
                "input": query,
                "chat_history": state.get("messages", [])
            })

            output = result.get("output", "No output from MCP Agent.")
            logger.info(f"MCPAgent finished with output: {output}")

            return {
                "mcp_results": {
                    "summary": output
                },
                "raw_output": output,
                "intermediate_steps": result.get("intermediate_steps", [])
            }

        except Exception as e:
            logger.error(f"Error in MCPAgent: {str(e)}", exc_info=True)
            return {
                "error": f"MCPAgent error: {str(e)}",
                "mcp_results": None
            }