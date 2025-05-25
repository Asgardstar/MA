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
    from agents.simulation_agent import SimulationAgent #
    from tools.simulation.matlab_simulation import stop_matlab_engine #
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


def interactive_chat(agent: SimulationAgent):
    """
    Manages an interactive chat session with the SimulationAgent.
    """
    chat_history = []
    print("\n--- Starting Interactive Chat with SimulationAgent ---")
    print("Type 'exit' or 'quit' to end the chat.")
    print("Agent: Hello! How can I help you with simulations today?")
    chat_history.append(AIMessage(content="Hello! How can I help you with simulations today?"))

    while True:
        try:
            current_query = input("You: ")
            if current_query.lower() in ["exit", "quit"]:
                print("Agent: Goodbye! Stopping MATLAB engine if active...")
                try:
                    stop_matlab_engine()
                except Exception as e_stop:
                    logger.error(f"Error stopping MATLAB engine: {e_stop}")
                print("Agent: Chat ended.")
                break

            if not current_query.strip():
                continue

            # The 'messages' for the agent state should include the full history plus the current query
            # The agent expects the current user message to be the last one in the list for processing
            current_turn_messages_for_agent = chat_history + [HumanMessage(content=current_query)]

            state = {
                "query": current_query, # The most recent query from the user for this turn
                "messages": current_turn_messages_for_agent,
                # 'context' can be added if needed, e.g., from a previous search agent
            }

            logger.info(f"\n--- Sending to SimulationAgent ---")
            logger.info(f"Current Query: {current_query}")
            logger.debug(f"Full message history for agent: {current_turn_messages_for_agent}")
            logger.info("-------------------------------")

            # Add user message to persistent chat_history for the next turn
            chat_history.append(HumanMessage(content=current_query))

            result = agent.process(state)
            final_answer = result.get('final_answer', "Agent did not provide a final answer.")
            simulation_results_if_any = result.get('simulation_results_if_any')

            print(f"Agent: {final_answer}")
            chat_history.append(AIMessage(content=final_answer)) # Add agent's response to history

            if result.get('error'):
                logger.error(f"Agent Error: {result.get('error')}")
            if simulation_results_if_any:
                logger.info(f"Simulation Execution Data from this turn: {simulation_results_if_any}")

            # Log intermediate steps if verbose logging for the agent_executor is off
            # but you still want to see them from the returned result.
            if logger.level <= logging.DEBUG: # or a specific flag
                raw_agent_output = result.get('raw_output_from_agent_executor', {})
                intermediate_steps = raw_agent_output.get('intermediate_steps', [])
                if intermediate_steps:
                    logger.debug("Intermediate Steps from AgentExecutor:")
                    for i, (action, observation) in enumerate(intermediate_steps):
                        logger.debug(f"  Step {i+1}:")
                        logger.debug(f"    Tool: {action.tool}")
                        logger.debug(f"    Tool Input: {action.tool_input}")
                        logger.debug(f"    Observation: {str(observation)[:1000]}...") # Log a snippet

        except KeyboardInterrupt:
            print("\nAgent: Chat interrupted by user. Goodbye! Stopping MATLAB engine if active...")
            try:
                stop_matlab_engine()
            except Exception as e_stop:
                logger.error(f"Error stopping MATLAB engine: {e_stop}")
            break
        except Exception as e:
            logger.error(f"Unexpected error during interactive chat: {e}", exc_info=True)
            print("Agent: I encountered an unexpected issue. Please try again.")
            # Optionally, decide if you want to clear chat_history or try to recover

if __name__ == "__main__":
    logger.info("--- Starting Isolated SimulationAgent Test (Interactive Mode) ---")
    try:
        # Make sure to set verbose=False in SimulationAgent's AgentExecutor
        # if you want to rely on the logger.debug for intermediate steps here
        # and not have double verbose output.
        simulation_agent_instance = SimulationAgent()
        logger.info("SimulationAgent instantiated successfully.")
    except Exception as e:
        logger.error(f"Failed to instantiate SimulationAgent: {e}", exc_info=True)
        sys.exit(1)

    interactive_chat(simulation_agent_instance)

    logger.info("--- Isolated SimulationAgent Test (Interactive Mode) Finished ---")