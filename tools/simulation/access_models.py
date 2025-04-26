from typing import Dict, Any, List
from data.knowledgegraph import get_agent_graph
import logging

logger = logging.getLogger(__name__)

def access_all_simulation_models() -> List[Dict[str, Any]]:
    """Access all simulation models from the knowledge graph"""
    graph = get_agent_graph()

    query = """
    MATCH (m:Model)
    OPTIONAL MATCH (m)-[:HAS_INPUT]->(input)
    OPTIONAL MATCH (m)-[:HAS_OUTPUT]->(output)
    RETURN m.id AS model_id, m.name AS model_name, 
           m.description AS description, m.purpose AS purpose,
           m.scope AS scope, m.fidelity AS fidelity,
           collect(DISTINCT {
               name: input.name,
               description: input.description,
               value: input.value,
               unit: input.unit,
               required: input.required
           }) AS inputs,
           collect(DISTINCT {
               name: output.name,
               description: output.description,
               value: output.value,
               unit: output.unit
           }) AS outputs
    """

    try:
        results = graph.query(query)
        models = []

        for record in results:
            model = {
                "id": record["model_id"],
                "name": record["model_name"],
                "description": {
                    "purpose": record["purpose"],
                    "scope": record["scope"],
                    "fidelity": record["fidelity"],
                    "details": record["description"]
                },
                "inputs": [inp for inp in record["inputs"] if inp["name"]],
                "outputs": [out for out in record["outputs"] if out["name"]]
            }
            models.append(model)

        logger.info(f"Retrieved {len(models)} simulation models")
        return models
    except Exception as e:
        logger.error(f"Error accessing simulation models: {str(e)}")
        raise