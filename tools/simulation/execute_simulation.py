# tools/simulation/execute_single.py
from typing import Dict, Any, List
from data.knowledgegraph import get_agent_graph
import logging

logger = logging.getLogger(__name__)


def execute_single_simulation(execution_data: Dict[str, Any]) -> Dict[str, Any]:
    """Execute single simulations after user confirmation"""
    simulations = execution_data.get("simulations", [])

    if not simulations:
        return {
            "status": "error",
            "message": "No simulations provided for execution"
        }

    # Check for user confirmation
    if not execution_data.get("confirmed", False):
        # Validate inputs for each simulation
        validation_results = []
        for simulation in simulations:
            model_id = simulation.get("model_id")
            inputs = simulation.get("inputs", {})

            validation = validate_simulation_inputs(model_id, inputs)
            validation_results.append({
                "model_id": model_id,
                "validation": validation
            })

        return {
            "status": "needs_confirmation",
            "message": "Please confirm simulation execution",
            "simulations": simulations,
            "validation_results": validation_results,
            "confirmation_required": True
        }

    # Execute simulations
    graph = get_agent_graph()
    execution_results = []

    try:
        for simulation in simulations:
            model_id = simulation.get("model_id")
            inputs = simulation.get("inputs", {})

            # In a real implementation, this would call the actual simulation engine
            # For now, we'll simulate execution
            logger.info(f"Executing simulation model {model_id} with inputs: {inputs}")

            # Mock simulation result
            import random
            result = {
                "model_id": model_id,
                "status": "completed",
                "output": {
                    "result_value": random.uniform(0, 100),
                    "units": "units",
                    "execution_time": random.uniform(0.1, 5.0)
                },
                "inputs_used": inputs
            }

            execution_results.append(result)

            # NOTE: Storage is disabled for now
            # Uncomment the following line when ready to store results
            # store_execution_result(graph, model_id, inputs, result)

        return {
            "status": "success",
            "message": f"Successfully executed {len(execution_results)} simulations",
            "results": execution_results
        }

    except Exception as e:
        logger.error(f"Error executing simulations: {str(e)}")
        return {
            "status": "error",
            "message": f"Execution failed: {str(e)}",
            "partial_results": execution_results
        }


def validate_simulation_inputs(model_id: str, inputs: Dict[str, Any]) -> Dict[str, Any]:
    """Validate inputs for a simulation model"""
    graph = get_agent_graph()

    # Fetch model requirements
    query = """
    MATCH (m:Model {id: $model_id})
    OPTIONAL MATCH (m)-[:HAS_INPUT]->(input)
    RETURN m, collect(DISTINCT {
        name: input.name,
        description: input.description,
        required: input.required,
        unit: input.unit
    }) AS inputs
    """

    try:
        result = graph.query(query, {"model_id": model_id})
        if not result:
            return {
                "valid": False,
                "errors": [f"Model {model_id} not found"]
            }

        model_data = result[0]
        required_inputs = model_data.get("inputs", [])

        errors = []
        warnings = []

        # Check required inputs
        for req_input in required_inputs:
            if req_input.get("required", False) and req_input["name"] not in inputs:
                errors.append(f"Missing required input: {req_input['name']}")

        # Check input formats (simplified validation)
        for input_name, input_value in inputs.items():
            # In a real implementation, validate format, units, etc.
            if input_value is None:
                warnings.append(f"Input '{input_name}' has null value")

        return {
            "valid": len(errors) == 0,
            "errors": errors,
            "warnings": warnings
        }

    except Exception as e:
        logger.error(f"Error validating inputs: {str(e)}")
        return {
            "valid": False,
            "errors": [f"Validation error: {str(e)}"]
        }


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