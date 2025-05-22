from typing import Dict, Any, List
from data.knowledgegraph import get_agent_graph
import logging

logger = logging.getLogger(__name__)

def access_all_simulation_models() -> List[Dict[str, Any]]:
    """
    Access all simulation models (labeled :model) and their interface parameters
    from the knowledge graph.
    """
    graph = get_agent_graph()

    query = """
    MATCH (model_node:model) 
    OPTIONAL MATCH (model_node)-[:HAS_INPUT]->(input_param:InterfaceParameter)
    OPTIONAL MATCH (model_node)-[:HAS_OUTPUT]->(output_param:InterfaceParameter)
    WITH model_node,
         collect(DISTINCT properties(input_param)) AS inputs_list, 
         collect(DISTINCT properties(output_param)) AS outputs_list 
    RETURN
        model_node.id AS model_id,
        model_node.name AS model_name,
        model_node.description AS model_description,
        model_node.fileName AS model_fileName,
        model_node.tool AS model_tool,
        model_node.modelTypeDetail AS model_type_detail,
        model_node.domain AS model_domain,
        model_node.scope AS model_scope,
        model_node.tags AS model_tags,
        model_node.version AS model_version,
        model_node.createdAt AS model_createdAt,
        model_node.updatedAt AS model_updatedAt,
        inputs_list,
        outputs_list
    ORDER BY model_node.name
    """

    try:
        results = graph.query(query)
        models_data = []

        if not results:
            logger.info("No simulation models (labeled :model) found in the knowledge graph.")
            return []

        for record in results:

            inputs = [
                inp for inp in record.get("inputs_list", [])
                if inp and isinstance(inp, dict) and inp.get("name")
            ]
            outputs = [
                out for out in record.get("outputs_list", [])
                if out and isinstance(out, dict) and out.get("name")
            ]

            model_entry = {
                "id": record.get("model_id"),
                "name": record.get("model_name"),
                "description": record.get("model_description"), 
                "fileName": record.get("model_fileName"),  
                "tool": record.get("model_tool"),
                "modelTypeDetail": record.get("model_type_detail"),
                "domain": record.get("model_domain"),
                "scope": record.get("model_scope"),
                "tags": record.get("model_tags", []), 
                "version": record.get("model_version"),
                "createdAt": str(record.get("model_createdAt")) if record.get("model_createdAt") else None, 
                "updatedAt": str(record.get("model_updatedAt")) if record.get("model_updatedAt") else None,
                "inputs": inputs,  
                "outputs": outputs 
            }
            models_data.append(model_entry)

        logger.info(f"Retrieved {len(models_data)} simulation models (labeled :model) with their parameters.")
        return models_data
    except Exception as e:
        logger.error(f"Error accessing simulation models (labeled :model): {str(e)}")

        raise RuntimeError(f"Failed to access simulation models (labeled :model) from graph: {e}")