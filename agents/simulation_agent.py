from typing import Dict, Any, List
from langchain.agents import AgentExecutor, create_react_agent
from langchain_core.messages import AIMessage 
from models.llm import get_llm
from prompts.simulation_agent_prompt import SIMULATION_AGENT_PROMPT 
from langchain.tools import Tool, StructuredTool 
from pydantic import BaseModel, Field
from tools.simulation.access_models import access_all_simulation_models
from tools.simulation.execute_simulation import execute_single_simulation
import logging
import json

logger = logging.getLogger(__name__)


class SimulationInstance(BaseModel):
    model_id: str = Field(description="The unique identifier of the simulation model to execute.")
    inputs: Dict[str, Any] = Field(description="A dictionary of input parameters and their values for the model.")

class ExecutionPayload(BaseModel): # This matches the structure expected by execute_single_simulation
    simulations: List[SimulationInstance] = Field(description="A list containing a single simulation instance to execute.")
    confirmed: bool = Field(description="Set to false for the first execution attempt to handle confirmation. Set to true if user has already confirmed.")


class SimulationAgent:
    def __init__(self):
        self.llm = get_llm("simulationagent") # Ensure 'simulationagent' is defined in your config.json for LLMs
        self.tools = self._create_tools()
        # The agent and executor are created using the ReAct prompt (SIMULATION_AGENT_PROMPT)
        # which includes {tools} and {tool_names} placeholders.
        self.agent = create_react_agent(
            llm=self.llm,
            tools=self.tools,
            prompt=SIMULATION_AGENT_PROMPT # Use the updated prompt
        )
        self.agent_executor = AgentExecutor(
            agent=self.agent,
            tools=self.tools,
            verbose=True, # Good for debugging
            handle_parsing_errors=True, # Important for ReAct agents
            max_iterations=7, # Increased max_iterations for multi-step reasoning
            return_intermediate_steps=True # Useful for seeing the agent's thoughts
        )

    def _create_tools(self) -> List[Tool]:
        """Create tools for the simulation agent."""

        # Wrapper for access_all_simulation_models (if it truly takes no arguments from LLM)
        # The new SIMULATION_AGENT_PROMPT says this tool takes no input.
        def access_models_wrapper(_: str = ""): # Tool needs to accept one string arg, even if unused
            """
            Helper to ensure access_all_simulation_models (which takes no args)
            can be called as a Langchain tool (which expects at least one string arg).
            """
            return access_all_simulation_models()

        tools = [
            Tool(
                name="access_simulation_models_info",
                func=access_models_wrapper, # Calls the updated access_all_simulation_models
                description="""
                Use this tool to get a list of ALL available simulation models and their detailed interface definitions.
                The returned information for each model includes its 'id', 'name', 'description', 'fileName',
                and importantly, 'inputs' and 'outputs' lists. Each item in these lists is a dictionary
                describing a parameter (with 'name', 'description', 'dataType', 'unit', 'required' status etc.).
                This tool takes NO INPUT. Call it directly when you need to know about available models or a specific model's interface.
                """
            ),
            # Using StructuredTool for execute_matlab_simulink_model for better input handling by LLM
            StructuredTool.from_function(
                func=execute_single_simulation, # Directly pass the function
                name="execute_matlab_simulink_model",
                args_schema=ExecutionPayload, # Use the Pydantic model for args
                description="""
                Use this tool to execute a specific Simulink model once ALL required parameters are gathered.
                Input MUST be a JSON object matching the args_schema.
                The 'simulations' field should be a list containing ONE simulation instance to run.
                Each instance needs 'model_id' (e.g., "motor_steady_speed_estimator_v1") and an 'inputs' dictionary
                (e.g., {"Voltage_V": 12.0, "Load_Torque_Nm": 0.02, ...}).
                Set the 'confirmed' field to 'false' for the first execution attempt of a task;
                the tool will return a message if user confirmation is needed.
                If the user confirms, call this tool again with 'confirmed: true'.
                The tool returns the simulation status, messages, and output data.
                """
            )
        ]
        return tools

    def process(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """
        Processes the simulation request using the ReAct agent and executor.
        The state should include the user 'query' and 'messages' (chat history).
        """
        query = state.get("query", "")
        chat_history = state.get("messages", []) # Langchain messages (HumanMessage, AIMessage)

        # Constructing input for the ReAct agent
        # The prompt expects 'input' and 'chat_history' and 'agent_scratchpad' (handled by AgentExecutor)
        agent_input = {
            "input": query,
            "chat_history": chat_history,
            # context from search_results might be useful if supervisor passes it
            "context": json.dumps(state.get("search_results", {})) if state.get("search_results") else ""
        }

        logger.info(f"SimulationAgent processing with input: {agent_input}")
        try:
            # The AgentExecutor runs the ReAct loop (Thought, Action, Observation, ...)
            # The 'output' from this is the LLM's "Final Answer" after its reasoning.
            result = self.agent_executor.invoke(agent_input)

            final_answer = result.get("output", "I am not sure how to respond to that regarding simulations.")
            intermediate_steps = result.get("intermediate_steps", []) # For logging/debugging

            logger.info(f"SimulationAgent final answer: {final_answer}")
            logger.debug(f"SimulationAgent intermediate steps: {intermediate_steps}")

            # The structure returned to the Supervisor via _simulation_agent_tool in multi_agent_system.py
            # should align with what the Supervisor expects.
            # For now, we assume the final_answer is the main piece of information.
            # If execute_matlab_simulink_model was called, its raw result is in the observation
            # of the last step. We need to decide if we parse that here or let the LLM summarize it.
            # The prompt guides the LLM to summarize.

            # If the last action was an execution, try to find its structured result
            # This is a bit more involved as intermediate_steps contains tuples of (AgentAction, Observation)
            # The Observation for execute_matlab_simulink_model would be the dictionary from execute_single_simulation
            raw_execution_results = None
            if intermediate_steps:
                last_action, last_observation = intermediate_steps[-1]
                if last_action.tool == "execute_matlab_simulink_model":
                    # last_observation is the dict returned by execute_single_simulation
                    raw_execution_results = last_observation


            return {
                "final_answer": final_answer, # The LLM's natural language response
                "raw_output_from_agent_executor": result, # For debugging
                "simulation_results_if_any": raw_execution_results # The structured data from execute_single_simulation
            }

        except Exception as e:
            logger.error(f"Error in SimulationAgent process: {str(e)}", exc_info=True)
            return {
                "final_answer": f"An error occurred in the Simulation Agent: {str(e)}",
                "error": str(e)
            }
