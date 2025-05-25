# simulation_agent_tests/isolated_simulation_agent.py

import logging
import os
import sys
from dotenv import load_dotenv
from langchain_core.messages import HumanMessage, AIMessage

# --- Path Setup ---
# Add the project root directory (asgardstar/ma) to the Python path
# This allows a_s_t to find modules like 'agents', 'tools', etc.
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

try:
    from agents.simulation_agent import SimulationAgent
    # from utils.utils import load_config # load_config is called within other modules if needed
except ImportError as e:
    print(f"Error importing SimulationAgent: {e}")
    print(f"Please ensure that '{PROJECT_ROOT}' is the correct project root and contains the 'agents' directory.")
    print("Run this script from the project root directory: 'python simulation_agent_tests/isolated_simulation_agent.py'")
    sys.exit(1)

# --- Logging Configuration ---
logging.basicConfig(
    level=logging.INFO, # Set to DEBUG for more verbose Langchain output
    format='%(asctime)s - %(levelname)s - %(name)s - %(module)s.%(funcName)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# --- Environment Variables ---
dotenv_path = os.path.join(PROJECT_ROOT, '.env')
if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path)
else:
    logger.warning(f".env file not found at {dotenv_path}. Ensure API keys and other secrets are set in your environment.")

def run_agent_interaction(agent: SimulationAgent, current_query: str, chat_history: list = None):
    """
    Interacts with the SimulationAgent for a single turn.
    """
    if chat_history is None:
        chat_history = []

    # The 'messages' for the agent state should include the full history plus the current query
    current_turn_messages = chat_history + [HumanMessage(content=current_query)]

    state = {
        "query": current_query, # The most recent query from the user for this turn
        "messages": current_turn_messages,
    }

    logger.info(f"\n--- Sending to SimulationAgent ---")
    logger.info(f"Current Query: {current_query}")
    if chat_history: # Log previous messages if they exist
        logger.info("Previous Chat History:")
        for msg in chat_history:
            logger.info(f"  {msg.type.upper()}: {msg.content}")
    logger.info("-------------------------------")


    try:
        result = agent.process(state)
        logger.info(f"--- SimulationAgent Raw Result ---")
        # Log the full result dictionary for better inspection during debugging
        logger.info(result)
        logger.info(f"--- Parsed Final Answer from Agent ---")
        final_answer = result.get('final_answer', "Agent did not provide a final answer.")
        logger.info(f"Final Answer: {final_answer}")

        if result.get('error'):
            logger.error(f"Agent Error: {result.get('error')}")
        if result.get('simulation_results_if_any'):
            logger.info(f"Simulation Execution Data: {result.get('simulation_results_if_any')}")

        # Detailed logging for ReAct steps if available and logging level is DEBUG
        if logger.level == logging.DEBUG and \
           result.get('raw_output_from_agent_executor') and \
           'intermediate_steps' in result.get('raw_output_from_agent_executor'):
            logger.debug("Intermediate Steps:")
            for step in result.get('raw_output_from_agent_executor')['intermediate_steps']:
                action, observation = step
                logger.debug(f"  Tool: {action.tool}, Input: {action.tool_input}")
                logger.debug(f"  Observation: {str(observation)[:500]}...") # Log a snippet of observation
        return result
    except Exception as e:
        logger.error(f"Unexpected error during agent interaction: {e}", exc_info=True)
        return {"final_answer": "An unexpected framework error occurred.", "error": str(e)}


if __name__ == "__main__":
    logger.info("--- Starting Isolated SimulationAgent Test ---")
    try:
        simulation_agent_instance = SimulationAgent()
        logger.info("SimulationAgent instantiated successfully.")
    except Exception as e:
        logger.error(f"Failed to instantiate SimulationAgent: {e}", exc_info=True)
        sys.exit(1)

    current_chat_history = []

    # --- Turn 1: User's initial query ---
    test_query_1 = "What's the estimated speed of the e-motor for 100V?"
    logger.info(f"\nInitiating Turn 1...")
    response_1 = run_agent_interaction(
        simulation_agent_instance,
        test_query_1,
        chat_history=current_chat_history
    )

    if not response_1 or response_1.get('error'):
        logger.error("Error or no response in Turn 1. Terminating test.")
        sys.exit(1)
    
    # Update chat history
    current_chat_history.append(HumanMessage(content=test_query_1))
    current_chat_history.append(AIMessage(content=response_1.get('final_answer')))

    # Check if agent asked for missing parameters as expected
    agent_reply_turn_1 = response_1.get('final_answer', '')
    expected_missing_params = ["Load Torque (Nm)", "Motor Torque Constant (Nm/A)", "Motor Back-EMF Constant (Vs/rad)", "Motor Armature Resistance (Ohm)"]
    all_params_asked = all(param in agent_reply_turn_1 for param in expected_missing_params)

    if not all_params_asked:
        logger.warning("Agent did not ask for all expected missing parameters after Turn 1. Please review LLM's Final Answer.")
        logger.info(f"Agent's Final Answer Turn 1: {agent_reply_turn_1}")
        logger.info("--- Test ending prematurely as agent did not ask for parameters as expected. ---")
        sys.exit(1)
    else:
        logger.info("Agent correctly asked for missing parameters in Turn 1.")


    # --- Turn 2: User provides the missing parameters ---
    # Parameter names from the previous successful log's "missing_inputs": 
    test_query_2 = "Okay, here are the values: Load_Torque_Nm is 0.05, motor_Kt is 0.1, motor_Ke is 0.1, and motor_Ra is 0.5 Ohm."

    
    logger.info(f"\nInitiating Turn 2...")
    response_2 = run_agent_interaction(
        simulation_agent_instance,
        test_query_2,
        chat_history=current_chat_history # Pass updated history
    )

    if not response_2 or response_2.get('error'):
        logger.error("Error or no response in Turn 2. Terminating test.")
        sys.exit(1)

    current_chat_history.append(HumanMessage(content=test_query_2))
    current_chat_history.append(AIMessage(content=response_2.get('final_answer')))

    # Check if agent is now asking for confirmation

    simulation_observation_turn_2 = response_2.get('simulation_results_if_any', {})
    agent_reply_turn_2 = response_2.get('final_answer', '').lower()

    if not (simulation_observation_turn_2.get('status') == 'needs_confirmation' or \
            "confirm" in agent_reply_turn_2 or \
            "proceed" in agent_reply_turn_2 or \
            "shall I run" in agent_reply_turn_2 or \
            "ready to execute" in agent_reply_turn_2):
        logger.warning(f"Agent did not ask for execution confirmation as expected after Turn 2.")
        logger.info(f"Observation status in Turn 2: {simulation_observation_turn_2.get('status')}")
        logger.info(f"Agent's Final Answer Turn 2: {response_2.get('final_answer')}")
        # Check if simulation accidentally completed
        if simulation_observation_turn_2.get('status') == 'completed':
            logger.info("UNEXPECTED: Simulation completed directly in Turn 2. Results:")
            logger.info(simulation_observation_turn_2)
        logger.info("--- Test ending prematurely as agent did not ask for confirmation. ---")
        sys.exit(1)
    else:
        logger.info("Agent correctly processed all parameters and is asking for confirmation in Turn 2.")

    # --- Turn 3: User confirms simulation execution ---
    test_query_3 = "Yes, please proceed with the simulation."
    logger.info(f"\nInitiating Turn 3...")
    response_3 = run_agent_interaction(
        simulation_agent_instance,
        test_query_3,
        chat_history=current_chat_history
    )

    if not response_3 or response_3.get('error'):
        logger.error("Error or no response in Turn 3. Terminating test.")
        sys.exit(1)
        
    # No need to update chat_history further for this test script's logic flow

    # Check if simulation completed successfully and returned results
    simulation_observation_turn_3 = response_3.get('simulation_results_if_any', {})
    if simulation_observation_turn_3.get('status') == 'completed' and 'Estimated_Speed_rpm' in simulation_observation_turn_3.get('output_data', {}):
        logger.info(f"SUCCESS! Simulation completed successfully in Turn 3!")
        logger.info(f"Simulation Output Data: {simulation_observation_turn_3.get('output_data')}")
        logger.info(f"Agent's Final Answer with results: {response_3.get('final_answer')}")
    else:
        logger.error(f"Simulation did not complete successfully or did not return expected output in Turn 3.")
        logger.error(f"Tool Observation from Turn 3: {simulation_observation_turn_3}")
        logger.error(f"Agent's Final Answer in Turn 3: {response_3.get('final_answer')}")

    # --- Cleanup ---
    try:
        from tools.simulation.matlab_simulation import stop_matlab_engine
        logger.info("Attempting to stop MATLAB engine if it was started...")
        stop_matlab_engine()
    except ImportError:
        logger.warning("Could not import stop_matlab_engine. Skipping MATLAB engine stop attempt.")
    except Exception as e:
        logger.error(f"Error stopping MATLAB engine: {e}")

    logger.info("--- Isolated SimulationAgent Test Finished ---")