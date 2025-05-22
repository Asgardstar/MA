# tools/simulation/execute_single.py
from typing import Dict, Any, List
from data.knowledgegraph import get_agent_graph
import logging
import os
from .matlab_simulation import run_simulink_model, stop_matlab_engine


logger = logging.getLogger(__name__)


def execute_single_simulation(execution_data: Dict[str, Any]) -> Dict[str, Any]:
    """
    Handles the execution request for one or more simulations, including validation,
    confirmation, and calling the underlying MATLAB/Simulink execution logic.
    """
    simulations_to_run = execution_data.get("simulations", [])

    if not simulations_to_run:
        return {"status": "error", "message": "No simulations provided for execution"}

    # --- User Confirmation Logic ---
    if not execution_data.get("confirmed", False):
        validation_results = []
        all_validations_passed = True
        for sim_data in simulations_to_run:
            model_id = sim_data.get("model_id")
            inputs = sim_data.get("inputs", {})
            if not model_id:
                validation_results.append({"model_id": "UNKNOWN", "validation": {"valid": False, "errors": ["model_id is missing"]}})
                all_validations_passed = False
                continue

            validation = validate_simulation_inputs(model_id, inputs) # Calls the previously updated validation function
            validation_results.append({"model_id": model_id, "validation": validation})
            if not validation.get("valid"):
                all_validations_passed = False

        if not all_validations_passed:
            return {
                "status": "validation_failed",
                "message": "Input validation failed for one or more models.",
                "validation_results": validation_results,
                "confirmation_required": True
            }
        
        return { # All validations passed, but still needs user confirmation
            "status": "needs_confirmation",
            "message": "Input validation passed. Please confirm simulation execution.",
            "simulations": simulations_to_run,
            "validation_results": validation_results,
            "confirmation_required": True
        }

    # --- Actual Simulation Execution (if confirmed) ---
    logger.info("User confirmed. Proceeding with simulation execution.")
    graph = get_agent_graph()
    execution_results_list = []

    # Determine the base directory for Simulink models.
    # Adjust this path if your simulink_models folder is located elsewhere relative to this script.
    try:
        current_script_dir = os.path.dirname(__file__) # tools/simulation
        project_root_dir = os.path.abspath(os.path.join(current_script_dir, '..', '..')) # Project root
        SIMULINK_MODELS_BASE_DIR = r"C:\Users\Duan\OneDrive - Students RWTH Aachen University\Simulink Models"
        if not os.path.isdir(SIMULINK_MODELS_BASE_DIR):
            # Fallback or raise error if critical
            logger.warning(f"Simulink models directory not found at: {SIMULINK_MODELS_BASE_DIR}. Trying current working directory.")
            SIMULINK_MODELS_BASE_DIR = os.path.join(os.getcwd(), "simulink_models")
            if not os.path.isdir(SIMULINK_MODELS_BASE_DIR):
                logger.error(f"Simulink models directory also not found at {SIMULINK_MODELS_BASE_DIR}. Models must be in MATLAB path or provide correct base directory.")
                SIMULINK_MODELS_BASE_DIR = None # Or raise an error
    except Exception as path_e:
        logger.error(f"Error determining Simulink models base directory: {path_e}")
        SIMULINK_MODELS_BASE_DIR = None


    for sim_data in simulations_to_run:
        model_id = sim_data.get("model_id")
        model_inputs = sim_data.get("inputs", {})

        logger.info(f"Preparing to execute model ID: {model_id} with inputs: {model_inputs}")

        simulink_file_name = None
        model_display_name = model_id # Default to id if name not found
        try:
            # 1. Get the Simulink model fileName from Neo4j
            model_info_query = "MATCH (m:model {id: $model_id}) RETURN m.fileName AS fileName, m.name AS modelName"
            model_graph_data = graph.query(model_info_query, {"model_id": model_id})
            
            if not model_graph_data or not model_graph_data[0] or not model_graph_data[0].get("fileName"):
                error_msg = f"Model metadata (fileName) not found in KG for ID {model_id}."
                logger.error(error_msg)
                execution_results_list.append({"model_id": model_id, "status": "error", "message": error_msg, "output": {}})
                continue
            
            simulink_file_name = model_graph_data[0]["fileName"]
            model_display_name = model_graph_data[0].get("modelName", model_id)
            logger.info(f"Retrieved fileName '{simulink_file_name}' for model '{model_display_name}' (ID: {model_id}).")

            # 2. Call the run_simulink_model function
            # For the motor steady-state model, stop_time '0' is appropriate.
            # This might need to be configurable per model in the future.
            sim_result_package = run_simulink_model(
                model_file_name=simulink_file_name,
                model_parameters=model_inputs,
                simulink_model_dir=SIMULINK_MODELS_BASE_DIR,
                stop_time='0'
            )

            execution_results_list.append({
                "model_id": model_id,
                "status": sim_result_package.get("status", "unknown"),
                "message": sim_result_package.get("message", "No message from simulation runner."),
                "output": sim_result_package.get("output_data", {}), # Contains actual simulation data or error details
                "inputs_used": model_inputs
            })

        except Exception as e:
            logger.error(f"Unexpected error processing simulation for model ID {model_id}: {e}", exc_info=True)
            execution_results_list.append({
                "model_id": model_id,
                "status": "error",
                "message": f"Unexpected framework error for {model_id}: {str(e)}",
                "output": {}
            })

    # --- Return overall results ---
    final_status = "error" # Default to error if no results
    final_message = "No simulations were processed or all failed."

    if execution_results_list:
        if all(res.get("status") == "completed" for res in execution_results_list):
            final_status = "success"
            final_message = f"Successfully executed {len(execution_results_list)} simulation(s)."
        elif any(res.get("status") == "completed" for res in execution_results_list):
            final_status = "partial_success" # Some succeeded, some failed
            final_message = "Some simulations completed successfully, while others encountered errors. Check individual results."
        else: # All must have failed or had unknown status
             final_message = f"All {len(execution_results_list)} simulation(s) failed or had issues. Check individual results."


    return {
        "status": final_status,
        "message": final_message,
        "results": execution_results_list
    }


def validate_simulation_inputs(model_id: str, provided_inputs: Dict[str, Any]) -> Dict[str, Any]:
    """
    Validate provided inputs for a given simulation model (labeled :model)
    against its definition in the knowledge graph.
    """
    graph = get_agent_graph()
    validation_result = {
        "valid": True,      # Overall validity status
        "errors": [],       # List of critical errors found
        "warnings": [],     # List of non-critical warnings
        "missing_inputs": [] # List of names of missing required inputs
    }

    # Cypher query to get input parameter definitions for a specific model
    # It matches the model by ID and its input parameters via :HAS_INPUT relationship
    query = """
    MATCH (model_node:model {id: $model_id}) // Use :model label and filter by id
    OPTIONAL MATCH (model_node)-[:HAS_INPUT]->(input_param:InterfaceParameter)
    WITH model_node, collect(DISTINCT properties(input_param)) AS inputs_definition_list
    RETURN model_node.name AS model_name, // Get model name for user-friendly messages
           inputs_definition_list
    """

    try:
        query_result = graph.query(query, {"model_id": model_id})

        # Check if the model was found in the graph
        if not query_result or not query_result[0] or not query_result[0].get("model_name"):
            validation_result["valid"] = False
            validation_result["errors"].append(f"Model with ID '{model_id}' not found or has no defined inputs in the knowledge graph.")
            return validation_result

        record = query_result[0]
        model_name = record.get("model_name", model_id) # Use model name or ID for messages
        
        # Extract and filter the list of input parameter definitions from the query result
        # Each item in model_defined_inputs is a dictionary of properties for an :InterfaceParameter node
        model_defined_inputs = [
            inp for inp in record.get("inputs_definition_list", [])
            if inp and isinstance(inp, dict) and inp.get("name") # Ensure parameter is valid and has a name
        ]

        # Handle cases where the model definition in KG has no inputs
        if not model_defined_inputs:
            if provided_inputs:
                # Warn if inputs were provided for a model defined with no inputs
                validation_result["warnings"].append(f"Model '{model_name}' (ID: {model_id}) is defined with no input parameters in the knowledge graph, but inputs were provided. These inputs will be ignored.")
            # If no inputs defined and no inputs provided, it's valid (validation_result["valid"] remains True)
            return validation_result # No further checks needed

        # Iterate through each parameter defined for the model in the knowledge graph
        for param_def in model_defined_inputs:
            param_name = param_def.get("name")
            # Check if the parameter is marked as required (assumes 'required':true/false in param_def)
            is_required = param_def.get("required", False) # Default to not required if 'required' key is missing

            if is_required and param_name not in provided_inputs:
                # If a required parameter is missing from the provided inputs
                validation_result["valid"] = False # Mark overall validation as failed
                error_msg = f"Missing required input for model '{model_name}': '{param_name}'."
                if param_def.get("description"):
                    error_msg += f" (Description: {param_def.get('description')})"
                validation_result["errors"].append(error_msg)
                validation_result["missing_inputs"].append(param_name)
            elif param_name in provided_inputs:
                # If parameter is provided, perform optional checks (e.g., for null values or basic type)
                user_value = provided_inputs[param_name]
                expected_type_str = param_def.get("dataType", "any").lower() # Get expected type from KG, default to 'any'

                if user_value is None: # Check for null values
                    validation_result["warnings"].append(f"Input '{param_name}' for model '{model_name}' has a null value.")
                # Basic type checks (can be expanded)
                elif (expected_type_str == "float" or expected_type_str == "double") and not isinstance(user_value, (float, int)):
                    validation_result["warnings"].append(f"Input '{param_name}' for model '{model_name}' expected type 'float', but got '{type(user_value).__name__}'. Will attempt conversion during execution.")
                elif expected_type_str == "integer" and not isinstance(user_value, int):
                    validation_result["warnings"].append(f"Input '{param_name}' for model '{model_name}' expected type 'integer', but got '{type(user_value).__name__}'.")
                elif expected_type_str == "string" and not isinstance(user_value, str):
                    validation_result["warnings"].append(f"Input '{param_name}' for model '{model_name}' expected type 'string', but got '{type(user_value).__name__}'.")
        
        # Check for any extra inputs provided by the user that are not defined for the model
        defined_param_names = {pdef.get("name") for pdef in model_defined_inputs if pdef.get("name")}
        for provided_param_name in provided_inputs:
            if provided_param_name not in defined_param_names:
                validation_result["warnings"].append(f"Provided input '{provided_param_name}' is not a defined input parameter for model '{model_name}'. It will be ignored or may cause errors if the underlying model uses it unexpectedly.")

    except Exception as e:
        logger.error(f"Error during input validation for model '{model_id}': {str(e)}")
        validation_result["valid"] = False # Mark as invalid on any exception during validation
        validation_result["errors"].append(f"An unexpected error occurred during input validation for model '{model_id}': {str(e)}")

    return validation_result


def store_execution_result(graph, model_id: str, inputs: Dict[str, Any], result: Dict[str, Any]):
    """Store execution result in the knowledge graph"""
    import json
    from datetime import datetime

    # Create a new execution node and connect it to the model
    query = """
    MATCH (m:Model {id: $model_id})
    CREATE (e:SimulationExecution {
        execution_time: datetime(),
        inputs: $inputs_json,
        outputs: $outputs_json,
        status: $status
    })
    CREATE (m)-[:WAS_EXECUTED]->(e)
    RETURN elementId(e) as execution_element_id
    """

    try:
        result_data = graph.query(query, {
            "model_id": model_id,
            "inputs_json": json.dumps(inputs),
            "outputs_json": json.dumps(result.get("output", {})),
            "status": result.get("status", "completed")
        })

        if result_data:
            execution_element_id = result_data[0]["execution_element_id"]
            logger.info(f"Stored execution result with elementId {execution_element_id} for model {model_id}")

        return execution_element_id
    except Exception as e:
        logger.error(f"Error storing execution result: {str(e)}")
        return None
    