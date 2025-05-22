
import json
import logging
import os
import sys

# --- Path Setup ---
project_root = os.path.abspath(os.path.dirname(__file__))
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from tools.simulation.matlab_simulation import run_simulink_model, stop_matlab_engine


# --- Logging Configuration ---
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(name)s - %(module)s - %(funcName)s - %(message)s'
)
logger = logging.getLogger(__name__)

if __name__ == "__main__":
    logger.info("--- Starting Simplified Direct MATLAB/Simulink Runner Test ---")

    # --- Configuration for the test ---

    SIMULINK_MODEL_FILE_NAME = "motor_speed_model.slx"

    SIMULINK_MODELS_DIRECTORY = r"C:\Users\Duan\OneDrive - Students RWTH Aachen University\Simulink Models"
    
    INPUT_PARAMETERS = {
        "Voltage_V": 20.0,
        "Load_Torque_Nm": 0.02,
        "motor_Kt": 0.1,
        "motor_Ke": 0.1,
        "motor_Ra": 0.5
    }
    EXPECTED_OUTPUT_VARIABLE_NAME = "Estimated_Speed_rpm"

    # --- Verify Simulink Model Directory ---
    if not os.path.isdir(SIMULINK_MODELS_DIRECTORY):
        logger.error(f"CRITICAL: Simulink models directory not found: {SIMULINK_MODELS_DIRECTORY}")
        sys.exit(1)
    logger.info(f"Using Simulink models directory: {SIMULINK_MODELS_DIRECTORY}")

    # --- Call run_simulink_model directly ---
    logger.info(f"Calling run_simulink_model for '{SIMULINK_MODEL_FILE_NAME}' with parameters: {INPUT_PARAMETERS}")
    
    simulation_result_package = None
    try:
        simulation_result_package = run_simulink_model(
            model_file_name=SIMULINK_MODEL_FILE_NAME,
            model_parameters=INPUT_PARAMETERS,
            simulink_model_dir=SIMULINK_MODELS_DIRECTORY,
            stop_time='0' 
        )
    except RuntimeError as e_matlab_engine_start:
        logger.error(f"MATLAB Engine failed to start: {e_matlab_engine_start}")
        sys.exit(1)
    except Exception as e_run_sim:
        logger.error(f"An unexpected error occurred during run_simulink_model call: {e_run_sim}", exc_info=True)
        sys.exit(1)

    # --- Analyze the result ---
    logger.info(f"\n--- Result from run_simulink_model ---")
    print(json.dumps(simulation_result_package, indent=2)) # Print the full result package

    status = simulation_result_package.get("status")
    output_data = simulation_result_package.get("output_data", {})
    extracted_value = output_data.get(EXPECTED_OUTPUT_VARIABLE_NAME)

    if status == "completed" and extracted_value is not None and isinstance(extracted_value, float):
        logger.info(f"✅ CORE TEST PASSED: Successfully executed and extracted '{EXPECTED_OUTPUT_VARIABLE_NAME}' = {extracted_value}")
    elif status == "completed_with_extraction_issue":
        logger.warning(f"   CORE TEST PARTIALLY PASSED: Simulation completed but failed to extract/convert '{EXPECTED_OUTPUT_VARIABLE_NAME}'.")
        logger.warning(f"   Message: {simulation_result_package.get('message')}")
        logger.warning(f"   Output Data Received: {output_data}")
    else:
        logger.error(f"   CORE TEST FAILED: Simulation status was '{status}'.")
        logger.error(f"   Message: {simulation_result_package.get('message')}")
        logger.error(f"   Output Data Received: {output_data}")

    # --- Stop the MATLAB engine ---
    try:
        logger.info("Attempting to stop MATLAB engine after test.")
        stop_matlab_engine()
    except Exception as e_stop:
        logger.error(f"Error stopping MATLAB engine after test: {e_stop}")

    logger.info("--- Simplified Direct MATLAB/Simulink Runner Test Finished ---")