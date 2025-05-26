# simulation_agent_tests/isolated_simulation_agent.py

import logging
import os
import sys
from dotenv import load_dotenv
from langchain_core.messages import HumanMessage, AIMessage

# --- Path Setup ---

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

try:
    from agents.simulation_agent import SimulationAgent #
    from tools.simulation.matlab_simulation import stop_matlab_engine #
except ImportError as e:
    print(f"Error importing SimulationAgent: {e}")
    print(f"Please ensure that '{PROJECT_ROOT}' is the correct project root and contains the 'agents' directory.")
    print("Run this script from the project root directory: 'python simulation_agent_tests/isolated_simulation_agent.py'")
    sys.exit(1)

# --- Logging Configuration ---
logging.basicConfig(
    level=logging.INFO, 
    format='%(asctime)s - %(levelname)s - %(name)s - %(module)s.%(funcName)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# --- ANSI Color Codes ---
GREEN = '\033[92m'
RESET_COLOR = '\033[0m'

# --- Environment Variables ---
dotenv_path = os.path.join(PROJECT_ROOT, '.env')
if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path)
else:
    logger.warning(f".env file not found at {dotenv_path}. Ensure API keys and other secrets are set in your environment.")


def interactive_chat(agent: SimulationAgent):
    """
    Manages an interactive chat session with the SimulationAgent,
    with colored output for user and agent messages.
    """
    chat_history = []
    # Initial agent message in green
    initial_agent_message = "Hello! How can I help you with simulations today?"
    print(f"\n--- Starting Interactive Chat with SimulationAgent ---")
    print("Type 'exit' or 'quit' to end the chat.")
    print(f"{GREEN}Agent: {initial_agent_message}{RESET_COLOR}")
    chat_history.append(AIMessage(content=initial_agent_message))

    while True:
        try:
            # Get user input
            raw_user_input = input(f"{GREEN}You: {RESET_COLOR}") 
            current_query = raw_user_input

            if current_query.lower() in ["exit", "quit"]:
                print(f"{GREEN}Agent: Goodbye! Stopping MATLAB engine if active...{RESET_COLOR}")
                try:
                    stop_matlab_engine()
                except Exception as e_stop:
                    logger.error(f"Error stopping MATLAB engine: {e_stop}")
                print(f"{GREEN}Agent: Chat ended.{RESET_COLOR}")
                break

            if not current_query.strip():
                continue

            current_turn_messages_for_agent = chat_history + [HumanMessage(content=current_query)]

            state = {
                "query": current_query,
                "messages": current_turn_messages_for_agent,
            }

            # Logging remains uncolored for clarity in log files
            logger.info(f"\n--- Sending to SimulationAgent ---")
            logger.info(f"Current Query: {current_query}")
            logger.debug(f"Full message history for agent: {current_turn_messages_for_agent}")
            logger.info("-------------------------------")

            chat_history.append(HumanMessage(content=current_query))

            result = agent.process(state)
            final_answer = result.get('final_answer', "Agent did not provide a final answer.")
            simulation_results_if_any = result.get('simulation_results_if_any')

            print(f"{GREEN}Agent: {final_answer}{RESET_COLOR}")
            chat_history.append(AIMessage(content=final_answer))

            if result.get('error'):
                logger.error(f"Agent Error: {result.get('error')}")
            if simulation_results_if_any:
                logger.info(f"Simulation Execution Data from this turn: {simulation_results_if_any}")

            if logger.level <= logging.DEBUG:
                raw_agent_output = result.get('raw_output_from_agent_executor', {})
                intermediate_steps = raw_agent_output.get('intermediate_steps', [])
                if intermediate_steps:
                    logger.debug("Intermediate Steps from AgentExecutor:")
                    for i, (action, observation) in enumerate(intermediate_steps):
                        logger.debug(f"  Step {i+1}:")
                        logger.debug(f"    Tool: {action.tool}")
                        logger.debug(f"    Tool Input: {action.tool_input}")
                        logger.debug(f"    Observation: {str(observation)[:1000]}...")

        except KeyboardInterrupt:
            print(f"\n{GREEN}Agent: Chat interrupted by user. Goodbye! Stopping MATLAB engine if active...{RESET_COLOR}")
            try:
                stop_matlab_engine()
            except Exception as e_stop:
                logger.error(f"Error stopping MATLAB engine: {e_stop}")
            break
        except Exception as e:
            logger.error(f"Unexpected error during interactive chat: {e}", exc_info=True)
            print(f"{GREEN}Agent: I encountered an unexpected issue. Please try again.{RESET_COLOR}")

if __name__ == "__main__":
    logger.info("--- Starting Isolated SimulationAgent Test ---")
    try:
        simulation_agent_instance = SimulationAgent()
        logger.info("SimulationAgent instantiated successfully.")
    except Exception as e:
        logger.error(f"Failed to instantiate SimulationAgent: {e}", exc_info=True)
        sys.exit(1)

    interactive_chat(simulation_agent_instance)

    logger.info("--- Isolated SimulationAgent Test Finished ---")