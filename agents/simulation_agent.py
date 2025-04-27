from typing import Dict, Any, List
from langchain.agents import AgentExecutor, create_react_agent
from langchain_core.messages import AIMessage
from models.llm import get_llm
from prompts.simulation_agent_prompt import SIMULATION_AGENT_PROMPT
from langchain.tools import Tool
from tools.simulation.access_models import access_all_simulation_models
from tools.simulation.execute_simulation import execute_single_simulation
import logging
import json

logger = logging.getLogger(__name__)


class SimulationAgent:
    def __init__(self):
        # Initialize LLM specifically for simulation agent
        self.llm = get_llm("simulationagent")
        self.tools = self._create_tools()
        self.agent = self._create_agent()
        self.agent_executor = self._create_executor()

    def _create_tools(self):
        """Create tools for the simulation agent"""

        # Wrapper function to make access_all_simulation_models accept an argument
        def access_models_wrapper(dummy_input: str = ""):
            """Wrapper to make access_all_simulation_models work as a tool"""
            return access_all_simulation_models()

        tools = [
            Tool(
                name="access_simulation_models",
                func=access_models_wrapper,
                description="""
                Access all simulation models in the knowledge graph.
                Returns information for each model including:
                - Model description (purpose, scope, fidelity)
                - Required inputs and outputs
                - Current inputs/outputs stored in the knowledge graph
                - Input/output details (name, description, format, values, units)
                No input required - just call this tool to get all models.
                """
            ),
            Tool(
                name="execute_simulation",
                func=lambda x: execute_single_simulation(json.loads(x)),
                description="""
                Execute one or more single simulations.
                Input should be a JSON string with:
                {
                    "simulations": [
                        {
                            "model_id": "string",
                            "inputs": {
                                "input_name": value,
                                ...
                            }
                        },
                        ...
                    ]
                }
                This will prompt for confirmation before execution.
                """
            )
        ]
        return tools

    def _create_agent(self):
        """Create the simulation agent"""
        return create_react_agent(
            llm=self.llm,
            tools=self.tools,
            prompt=SIMULATION_AGENT_PROMPT
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
        """Process the simulation request in a simplified way for tool integration"""
        query = state.get("query", "")
        context = self._build_context(state)

        try:
            # Run the agent
            result = self.agent_executor.invoke({
                "input": query,
                "context": context,
                "chat_history": state.get("messages", [])
            })

            # Extract results
            output = result.get("output", "")
            intermediate_steps = result.get("intermediate_steps", [])

            # Parse the results
            simulation_results = self._parse_simulation_results(output, intermediate_steps)

            logger.info("Simulation agent completed processing")

            return {
                "simulation_results": simulation_results,
                "raw_output": output,
                "intermediate_steps": intermediate_steps
            }

        except Exception as e:
            logger.error(f"Error in simulation agent: {str(e)}")
            return {
                "error": f"Simulation error: {str(e)}",
                "simulation_results": None
            }

    def _build_context(self, state: Dict[str, Any]) -> str:
        """Build context from the current state"""
        context_parts = []

        if state.get("search_results"):
            context_parts.append(f"Search Results: {json.dumps(state['search_results'], indent=2)}")

        if state.get("user_inputs"):
            context_parts.append(f"User Inputs: {json.dumps(state['user_inputs'], indent=2)}")

        return "\n\n".join(context_parts)

    def _parse_simulation_results(self, output: str, intermediate_steps: list) -> Dict[str, Any]:
        """Parse simulation results from the agent output"""
        results = {
            "raw_output": output,
            "models_accessed": [],
            "executions": [],
            "summary": ""
        }

        # Extract results from intermediate steps
        for step in intermediate_steps:
            if isinstance(step, tuple) and len(step) == 2:
                action, observation = step
                if action.tool == "access_simulation_models":
                    results["models_accessed"].append(observation)
                elif action.tool == "execute_simulation":
                    results["executions"].append({
                        "type": "single_simulation",
                        "result": observation
                    })

        # Extract summary from output
        if "summary:" in output.lower():
            summary_start = output.lower().find("summary:") + 8
            results["summary"] = output[summary_start:].strip()
        else:
            results["summary"] = output.strip()

        return results