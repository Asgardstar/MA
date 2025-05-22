# tools/simulation/matlab_simulation.py
import matlab.engine
import logging
import os
from typing import Dict, Any

logger = logging.getLogger(__name__)

# --- MATLAB Engine Management ---
_matlab_engine_instance = None

def get_matlab_engine():
    """
    Starts and returns a global MATLAB engine instance if not already started.
    """
    global _matlab_engine_instance
    if _matlab_engine_instance is None: # Could also check for validity if engine can become invalid
        try:
            logger.info("Starting MATLAB engine...")
            _matlab_engine_instance = matlab.engine.start_matlab()
            logger.info("MATLAB engine started successfully.")
        except matlab.engine.EngineError as e:
            logger.error(f"Failed to start MATLAB engine: {e}")
            raise RuntimeError(f"MATLAB Engine could not be started: {e}") from e
        except Exception as e:
            logger.error(f"An unexpected error occurred while starting MATLAB engine: {e}")
            raise RuntimeError(f"Unexpected error starting MATLAB engine: {e}") from e
    return _matlab_engine_instance

def stop_matlab_engine():
    """
    Stops the global MATLAB engine instance if it's running.
    Intended to be called on application exit.
    """
    global _matlab_engine_instance
    if _matlab_engine_instance:
        try:
            logger.info("Attempting to stop MATLAB engine...")
            _matlab_engine_instance.quit()
            logger.info("MATLAB engine stopped successfully.")
        except Exception as e:
            logger.error(f"Error stopping MATLAB engine: {e}")
        finally:
            _matlab_engine_instance = None

# --- Simulink Model Execution Core Logic ---
def run_simulink_model(
    model_file_name: str,
    model_parameters: Dict[str, Any],
    simulink_model_dir: str = None,
    stop_time: str = '0' # Default stop time, suitable for steady-state models
) -> Dict[str, Any]:
    """
    Runs a specified Simulink model with given parameters using the MATLAB Engine.
    Extracts a specific output variable ('Estimated_Speed_rpm') from the simulation results.
    """
    eng = get_matlab_engine() # Get (or start) the MATLAB engine
    sim_output_data = {}      # To store extracted simulation data or error messages
    status = "unknown"        # Overall status of the simulation run
    message = ""              # User-friendly message about the outcome
    original_matlab_dir = None # To restore MATLAB's path after cd

    try:
        # Model name for MATLAB commands (without .slx extension)
        sim_model_name_for_cmd = os.path.splitext(model_file_name)[0]

        # Change MATLAB's current directory if a specific model directory is provided
        if simulink_model_dir:
            abs_model_dir = os.path.abspath(simulink_model_dir)
            if os.path.isdir(abs_model_dir):
                logger.info(f"Changing MATLAB current directory to: {abs_model_dir}")
                original_matlab_dir = eng.cd(abs_model_dir, nargout=1)
            # If dir not found, will rely on MATLAB path or full path in load_system

        logger.info(f"Preparing to run Simulink model: {model_file_name} (command name: {sim_model_name_for_cmd})")

        # Explicitly load the Simulink model into memory
        try:
            model_path_to_load = model_file_name
            if simulink_model_dir and original_matlab_dir: # If cd to model dir was successful
                model_path_to_load = model_file_name # Just name is fine as we are in the directory
            elif simulink_model_dir: # If dir was given but cd might have failed or wasn't absolute
                model_path_to_load = os.path.join(simulink_model_dir, model_file_name)
                if not os.path.exists(model_path_to_load):
                    logger.warning(f"Model path {model_path_to_load} does not exist. Falling back to model name '{sim_model_name_for_cmd}'.")
                    model_path_to_load = sim_model_name_for_cmd
            
            # Check if model is already loaded
            if not eng.eval(f"bdIsLoaded('{sim_model_name_for_cmd}')", nargout=1):
                logger.info(f"Model '{sim_model_name_for_cmd}' not loaded. Attempting to load from: {model_path_to_load}")
                eng.load_system(model_path_to_load, nargout=0)
                logger.info(f"Simulink model '{model_path_to_load}' loaded successfully.")
            else:
                logger.info(f"Simulink model '{sim_model_name_for_cmd}' is already loaded.")
        except matlab.engine.MatlabExecutionError as load_err:
            logger.error(f"Failed to load Simulink model '{model_file_name}': {load_err}")
            raise # Re-throw to be caught by the outer try-except block

        # Set model parameters in MATLAB workspace
        for param_name, param_value in model_parameters.items():
            if isinstance(param_value, list) and all(isinstance(i, list) for i in param_value): # For list of lists (e.g. timeseries data)
                eng.workspace[param_name] = matlab.double(param_value)
            else: # For scalars (float, int, str)
                eng.workspace[param_name] = param_value
            logger.info(f"Set MATLAB workspace variable: {param_name} = {param_value}")

        # Set simulation stop time using set_param
        eng.eval(f"set_param('{sim_model_name_for_cmd}', 'StopTime', '{stop_time}')", nargout=0)
        logger.info(f"Set StopTime = {stop_time} for model '{sim_model_name_for_cmd}'.")

        # Run the simulation
        logger.info(f"Running simulation for '{sim_model_name_for_cmd}'...")
        sim_output_object_name = "py_sim_run_output" # Name for the SimulationOutput object in MATLAB workspace
        eng.eval(f"{sim_output_object_name} = sim('{sim_model_name_for_cmd}');", nargout=0)
        # simulation_output_obj = eng.workspace[sim_output_object_name] # Get the proxy object
        logger.info(f"Simulation for '{sim_model_name_for_cmd}' completed. Output stored in MATLAB variable '{sim_output_object_name}'.")

        # --- Result Extraction from SimulationOutput object ---
        output_var_name_in_simulink = "Estimated_Speed_rpm" # Variable name set in "To Workspace" block
        data_point_matlab = None # Will hold the raw data object from MATLAB

        try:
            logger.info(f"Attempting to extract '{output_var_name_in_simulink}' from '{sim_output_object_name}' in MATLAB.")
            
            # Preferred method: If 'To Workspace' saved as Timeseries, access .Data
            # This eval string attempts to get sim_run_output.Estimated_Speed_rpm.Data
            eval_str_data = f"{sim_output_object_name}.{output_var_name_in_simulink}.Data"
            try:
                data_point_matlab = eng.eval(eval_str_data, nargout=1)
                logger.info(f"Successfully retrieved using '{eval_str_data}'. Type: {type(data_point_matlab)}")
            except matlab.engine.MatlabExecutionError:
                logger.warning(f"Could not access '{eval_str_data}'. Trying direct property access.")
                # Fallback: If not a timeseries with .Data, or saved as Array, try direct property
                eval_str_direct = f"{sim_output_object_name}.{output_var_name_in_simulink}"
                data_point_matlab = eng.eval(eval_str_direct, nargout=1)
                logger.info(f"Successfully retrieved using '{eval_str_direct}'. Type: {type(data_point_matlab)}")

            if data_point_matlab is None or (isinstance(data_point_matlab, matlab.double) and eng.isempty(data_point_matlab)):
                raise ValueError(f"Retrieved data for '{output_var_name_in_simulink}' is None or empty.")

            # Convert retrieved MATLAB data (expected to be a scalar or 1x1 array) to Python float
            if isinstance(data_point_matlab, matlab.double):
                logger.info(f"'{output_var_name_in_simulink}' is matlab.double. Size: {data_point_matlab.size}")
                value_list = data_point_matlab.tolist() # Converts to Python list (possibly nested)
                
                # Unwrap if nested (e.g. [[value]])
                current_val = value_list
                while isinstance(current_val, list) and len(current_val) == 1:
                    current_val = current_val[0]
                
                if isinstance(current_val, (float, int)):
                    sim_output_data[output_var_name_in_simulink] = float(current_val)
                    logger.info(f"Extracted numeric value: {sim_output_data[output_var_name_in_simulink]}")
                else:
                    raise ValueError(f"Content after tolist() and unwrap is not a number: {current_val}")
            elif isinstance(data_point_matlab, (float, int)): # If eng.eval already gave a Python type
                 sim_output_data[output_var_name_in_simulink] = float(data_point_matlab)
                 logger.info(f"Retrieved as Python scalar: {sim_output_data[output_var_name_in_simulink]}")
            else:
                raise TypeError(f"Unexpected data type '{type(data_point_matlab)}' for extracted data.")

            status = "completed"
            message = f"Simulink model '{model_file_name}' executed and output '{output_var_name_in_simulink}' extracted."

        except Exception as extraction_err: # Catch errors specifically from extraction attempts
            status = "completed_with_extraction_issue"
            message = f"Simulation ran, but failed to extract/convert output '{output_var_name_in_simulink}': {extraction_err}"
            sim_output_data["extraction_error_detail"] = str(extraction_err)
            logger.warning(message)
        
        logger.info(f"Final extracted sim_output_data for '{model_file_name}': {sim_output_data}")

    except matlab.engine.MatlabExecutionError as matlab_err:
        status = "error"
        message = f"MATLAB Execution Error for model '{model_file_name}': {str(matlab_err)}"
        sim_output_data["error_details"] = message
        logger.error(message)
    except RuntimeError as r_err: # Catches engine start errors from get_matlab_engine
        status = "error"
        message = str(r_err)
        sim_output_data["error_details"] = message
        logger.error(message)
    except Exception as e:
        status = "error"
        message = f"General error executing Simulink model '{model_file_name}': {str(e)}"
        sim_output_data["error_details"] = message
        logger.error(message, exc_info=True) # Log full traceback for unexpected errors
    finally:
        if original_matlab_dir and eng: # Restore MATLAB's original directory
            try:
                eng.cd(original_matlab_dir, nargout=0)
                logger.info(f"Restored MATLAB current directory to: {original_matlab_dir}")
            except Exception as cd_err: # Catch errors if engine died or dir is invalid
                logger.error(f"Failed to restore MATLAB directory: {cd_err}")
        # Global engine instance is not stopped here; call stop_matlab_engine() on application exit.

    return {
        "status": status,
        "message": message,
        "output_data": sim_output_data # Contains extracted data or error messages
    }