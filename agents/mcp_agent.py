# agents/mcp_agent.py
from typing import Dict, Any
from langchain.agents import AgentExecutor, create_react_agent
from models.llm import get_llm
from prompts.mcp_agent_prompt import MCP_AGENT_PROMPT # Import the new prompt
from langchain.tools import Tool
from tools.mcp_tools import mcp_chat_tool
import logging

logger = logging.getLogger(__name__)


class MCPAgent:
    def __init__(self):
        # Initialize LLM for the MCP Agent
        self.llm = get_llm("mcpagent")
        self.tools = self._create_tools()
        self.agent = self._create_agent()
        self.agent_executor = self._create_executor()

    def _create_tools(self) -> list[Tool]:
        """Create tools for the MCP Agent"""
        logger.info("Creating MCP tools...")
        mcp_tool = Tool(
            name="mcp_chat",
            func=mcp_chat_tool,
            description="Use this tool to interact with the MCP server to call external capabilities. The input should be a clear and specific instruction detailing what needs to be done."
        )
        return [mcp_tool]

    def _create_agent(self):
        """Create the MCP agent"""
        return create_react_agent(
            llm=self.llm,
            tools=self.tools,
            prompt=MCP_AGENT_PROMPT
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
        """Process the request by invoking the agent executor."""
        query = state.get("query", "")
        logger.info(f"MCPAgent processing query: {query}")

        try:
            # Run the agent executor
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
            logger.error(f"Error in MCPAgent: {str(e)}")
            return {
                "error": f"MCPAgent error: {str(e)}",
                "mcp_results": None
            }