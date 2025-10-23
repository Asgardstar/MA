# agents/simulation_agent.py
import logging
import json
from typing import Dict, Any

from langchain.agents import AgentExecutor, create_react_agent
from langchain_core.messages import AIMessage
from langchain.tools import Tool

from models.llm import get_llm
from prompts.simulation_agent_prompt import SIMULATION_AGENT_PROMPT # We will update this later
from tools.mcp_tools import mcp_chat_tool 

logger = logging.getLogger(__name__)


class SimulationAgent:
    def __init__(self):
        # Initialize LLM
        self.llm = get_llm("simulationagent")
        # Create the core tool: mcp_chat_tool
        self.tools = self._create_tools()
        # Create the Agent and Executor
        self.agent = self._create_agent()
        self.agent_executor = self._create_executor()

    def _create_tools(self) -> list[Tool]:
        """
        Create tools for the Simulation Agent.
        The core tool is mcp_chat_tool, which connects to all MCP servers and executes commands.
        """
        logger.info("Creating tools for the new unified Simulation Agent...")
        simulation_mcp_tool = Tool(
            name="execute_simulation_or_code",
            func=mcp_chat_tool,
            description="""Use this tool to perform any simulation or code execution task. 
            The input should be a clear and specific natural language instruction detailing what needs to be done. 
            This tool can access various capabilities like running battery models, motor speed calculations, or generating and executing new MATLAB scripts."""
        )
        return [simulation_mcp_tool]

    def _create_agent(self):
        """Create the Agent"""
        return create_react_agent(
            llm=self.llm,
            tools=self.tools,
            prompt=SIMULATION_AGENT_PROMPT # We will update this prompt later
        )

    def _create_executor(self):
        """Create the Agent Executor"""
        return AgentExecutor(
            agent=self.agent,
            tools=self.tools,
            verbose=True,
            handle_parsing_errors=True,
            max_iterations=5,
            return_intermediate_steps=True
        )

    def process(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """
        Process the request by invoking the agent executor.
        This agent's core task is to understand the user's simulation/code needs and use mcp_chat_tool to fulfill them.
        """
        query = state.get("query", "")
        logger.info(f"New SimulationAgent processing query: {query}")

        try:
            # Run the agent executor
            result = self.agent_executor.invoke({
                "input": query,
                "chat_history": state.get("messages", [])
            })

            output = result.get("output", "No output from Simulation Agent.")
            
            logger.info(f"New SimulationAgent finished with output: {output}")

            # Return a unified simulation_results structure
            return {
                "simulation_results": {
                    "summary": output
                },
                "raw_output": output,
                "intermediate_steps": result.get("intermediate_steps", [])
            }

        except Exception as e:
            logger.error(f"Error in the new SimulationAgent: {str(e)}")
            return {
                "error": f"SimulationAgent error: {str(e)}",
                "simulation_results": None
            }