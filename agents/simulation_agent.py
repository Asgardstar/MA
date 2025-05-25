
import logging
import json
from typing import Dict, Any, List

from langchain.agents import AgentExecutor, create_react_agent
from langchain_core.messages import AIMessage
from langchain_core.tools import Tool

from models.simulation_schemas import ExecutionPayload
from pydantic import ValidationError

from models.llm import get_llm
from prompts.simulation_agent_prompt import SIMULATION_AGENT_PROMPT
from tools.simulation.access_models import access_all_simulation_models
from tools.simulation.execute_simulation import execute_single_simulation

logger = logging.getLogger(__name__)

# --- Python Function Implementation  ---
def execute_matlab_simulink_model_implementation(payload_str: str) -> Dict[str, Any]: 
    """
    Use this tool to execute a specific Simulink model OR to validate parameters.
    The input for this tool MUST be a valid JSON STRING.
    This JSON string must represent an object structured as follows:
    '{
        "simulations": [
            {
                "model_id": "your_chosen_model_id",
                "inputs": {"parameter_name": "parameter_value"}
            }
        ],
        "confirmed": false
    }'
    Set 'confirmed' to false for initial validation or if inputs are partial.
    If validation (done by the tool) fails due to missing inputs, the tool's observation will indicate this.
    Your next step then is to ASK THE USER for these specific missing inputs.
    Only when all inputs are present and confirmed by the user, set 'confirmed' to true to run the simulation.
    """
    logger.info(f"Executing 'execute_matlab_simulink_model_implementation' with raw payload_str: {payload_str}")
    payload_dict = None
    try:
        payload_dict = json.loads(payload_str)
        logger.info(f"Successfully parsed payload_str to dict: {payload_dict}")
        payload = ExecutionPayload.model_validate(payload_dict)
        logger.info(f"Successfully validated dict with ExecutionPayload: {payload}")
        return execute_single_simulation(payload.model_dump())
    except json.JSONDecodeError as e:
        error_msg = f"Invalid JSON string provided. Error: {e}. Input: '{payload_str}'"
        logger.error(error_msg)
        return {"status": "error", "message": error_msg, "output_data": {"error_details": error_msg}}
    except ValidationError as e:
        error_details_list = e.errors()
        error_msg = f"Invalid payload structure. Errors: {json.dumps(error_details_list, indent=2)}. Input: '{payload_str}', Parsed: {payload_dict if payload_dict is not None else 'JSON parse fail'}"
        logger.error(error_msg)
        return {"status": "validation_failed", "message": "Payload validation failed.", "error_details_pydantic": error_details_list, "confirmation_required": True}
    except Exception as e:
        error_msg = f"Unexpected error in tool. Error: {type(e).__name__} - {e}. Input: '{payload_str}'"
        logger.error(error_msg, exc_info=True)
        return {"status": "error", "message": error_msg, "output_data": {"error_details": error_msg}}
# --- End Python Function Implementation ---

class SimulationAgent:
    def __init__(self):
        self.llm = get_llm("simulationagent")
        self.tools = self._create_tools()
        self.agent = create_react_agent(
            llm=self.llm,
            tools=self.tools,
            prompt=SIMULATION_AGENT_PROMPT
        )
        self.agent_executor = AgentExecutor(
            agent=self.agent,
            tools=self.tools,
            verbose=True,
            handle_parsing_errors=True,
            max_iterations=10,
            return_intermediate_steps=True
        )

    def _create_tools(self) -> List[Tool]:
        def access_models_wrapper(_: str = ""):
            return access_all_simulation_models()

        tools = [
            Tool(
                name="access_simulation_models_info",
                func=access_models_wrapper,
                description="""Use this tool to get a list of ALL available simulation models and their detailed interface definitions. The returned information for each model includes its 'id', 'name', 'description', 'fileName', and importantly, 'inputs' and 'outputs' lists. Each item in these lists is a dictionary describing a parameter (with 'name', 'description', 'dataType', 'unit', 'required' status etc.). This tool takes NO INPUT. Call it directly when you need to know about available models or a specific model's interface."""
            ),
          
            Tool(
                name="execute_matlab_simulink_model", 
                func=execute_matlab_simulink_model_implementation, 
                description=execute_matlab_simulink_model_implementation.__doc__, 
            ),
        ]
        return tools

    def process(self, state: Dict[str, Any]) -> Dict[str, Any]:
        
        query = state.get("query", "")
        chat_history = state.get("messages", [])

        agent_input = {
            "input": query,
            "chat_history": chat_history,
            "context": json.dumps(state.get("search_results", {})) if state.get("search_results") else ""
        }

        logger.info(f"SimulationAgent processing with input: {agent_input}")
        try:
            result = self.agent_executor.invoke(agent_input)
            final_answer = result.get("output", "I am not sure how to respond to that regarding simulations.")
            intermediate_steps = result.get("intermediate_steps", [])
            raw_execution_results = None

            if intermediate_steps:
                last_action, last_observation = intermediate_steps[-1]
                if last_action.tool == "execute_matlab_simulink_model": 
                    raw_execution_results = last_observation
            
            return {
                "final_answer": final_answer,
                "raw_output_from_agent_executor": result,
                "simulation_results_if_any": raw_execution_results
            }
        except Exception as e:
            logger.error(f"Error in SimulationAgent process: {str(e)}", exc_info=True)
            error_message = str(e)
            if isinstance(e, ValidationError):
                 error_details = e.errors()
                 error_message = f"Pydantic Validation Error: {json.dumps(error_details, indent=2)}"
            elif hasattr(e, 'errors') and callable(e.errors):
                try:
                    error_dict_list = e.errors()
                    if isinstance(error_dict_list, list):
                        error_message = f"Pydantic Validation Error: {json.dumps(error_dict_list, indent=2)}"
                    else:
                        error_message = f"Pydantic Validation Error (non-standard): {str(error_dict_list)}"
                except Exception as json_e:
                    logger.error(f"Could not serialize Pydantic error to JSON: {json_e}")
            return {
                "final_answer": f"An error occurred in the Simulation Agent: {error_message}",
                "error": error_message
            }