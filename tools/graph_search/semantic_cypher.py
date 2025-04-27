# tools/graph_search/semantic_cypher.py
import logging
from typing import Dict, Any, List
from langchain_neo4j import GraphCypherQAChain
from langchain.prompts.prompt import PromptTemplate
from models.llm import get_llm
from models.embedding import get_embedding_model
from utils.utils import load_config
import neo4j
from data.knowledgegraph import get_agent_graph
from tools.graph_search.cypher_generation_template import CYPHER_GENERATION_TEMPLATE
import os

logger = logging.getLogger(__name__)

# Get the configuration
NEO4J_ADMIN = os.getenv('NEO4J_ADMIN')
config = load_config()
neo4j_config = config.get("neo4j", {})
neo4j_agent_config = config.get("neo4j_agent", {})
rag_config = config.get("rag", {})


def semantic_search(query: str, limit: int = 5) -> List[Dict[str, Any]]:
    """Perform semantic search on the knowledge graph using the user query"""
    # Get configuration
    uri = neo4j_config.get("uri", "")
    auth = (neo4j_config.get("username", ""), NEO4J_ADMIN)
    db_name = neo4j_config.get("database", "")

    # Get similarity threshold from config
    similarity_threshold = rag_config.get("similarity_threshold", 0.7)

    # Get embedding model
    embedding_model = get_embedding_model()

    results = []

    logger.info(f"Performing semantic search for: '{query}'")
    driver = neo4j.GraphDatabase.driver(uri, auth=auth)

    query_embedding = embedding_model.encode(query).tolist()

    cypher_query = '''
    MATCH (n)
    WITH n, vector.similarity.cosine(n.description_embedding, $queryEmbedding) AS score
    WHERE score > $threshold
    RETURN labels(n) AS labels, n.name AS name, n.description AS description, score
    ORDER BY score DESC
    LIMIT $limit
    '''

    try:
        related_nodes, _, _ = driver.execute_query(
            cypher_query,
            queryEmbedding=query_embedding,
            threshold=similarity_threshold,
            limit=limit,
            database_=db_name
        )

        for record in related_nodes:
            node_labels = record.get("labels", [])
            label = node_labels[0] if node_labels else "unknown"

            results.append({
                "label": label,
                "name": record.get("name", ""),
                "description": record.get("description", ""),
                "score": record.get("score", 0)
            })

        logger.info(f"Found {len(results)} results for semantic search")
    except Exception as e:
        logger.error(f"Error during semantic search: {str(e)}")
        results = []  # Return empty results on error
    finally:
        driver.close()

    return results


def format_semantic_results(results: List[Dict[str, Any]]) -> str:
    """Format semantic search results for inclusion in Cypher prompt"""
    if not results:
        return "No semantically similar nodes were found. You'll need to write a more general query."

    formatted = ""
    for i, result in enumerate(results, 1):
        formatted += f"{i}. Node Label: {result.get('label')}\n"
        formatted += f"   Name: {result.get('name')}\n"
        formatted += f"   Description: {result.get('description')}\n"
        formatted += f"   Similarity Score: {result.get('score'):.4f}\n\n"

    return formatted


def semantic_cypher_search(query: str) -> str:
    logger.info(f"Processing query: {query}")

    # Perform semantic search directly with the user query
    semantic_results = semantic_search(
        query,
        limit=rag_config.get("top_k", 5)
    )

    formatted_semantic_results = format_semantic_results(semantic_results)

    cypher_prompt = PromptTemplate.from_template(CYPHER_GENERATION_TEMPLATE)

    # Fixed: Pass agent name to get_llm
    llm = get_llm("searchagent")  # or whatever agent name is appropriate for search
    graph = get_agent_graph()

    logger.info("Initializing GraphCypherQAChain")
    cypher_search = GraphCypherQAChain.from_llm(
        llm,
        graph=graph,
        verbose=rag_config.get("verbose", True),
        cypher_prompt=cypher_prompt,
        allow_dangerous_requests=True,
        top_k=100,
    )

    try:
        chain_response = cypher_search.invoke({
            "query": query,
            "semantic_results": formatted_semantic_results
        })

        # Extract the result from the invoke() response
        result_text = chain_response.get("result", "No results found")
        return result_text

    except neo4j.exceptions.CypherSyntaxError as e:
        # Log the error and try to recover
        logger.error(f"Cypher syntax error: {str(e)}")
        error_message = f"I encountered an error in the database query: {str(e)}\n\n"
        return error_message

    except Exception as e:
        # Handle any other exceptions
        logger.error(f"Error in semantic_cypher_search: {str(e)}")
        return f"I encountered an error while processing your query: {str(e)}. Please try rephrasing your question."