from langchain_neo4j import Neo4jGraph
from utils.utils import load_config
import logging

logger = logging.getLogger(__name__)

# Get Neo4j configuration from the centralized config
config = load_config()

def get_graph():
    """Returns a fresh Neo4jGraph instance using the current configuration."""
    neo4j_config = config.get("neo4j", {})

    # Extract connection details
    url = neo4j_config.get("uri", "")
    username = neo4j_config.get("username", "")
    password = neo4j_config.get("password", "")
    database = neo4j_config.get("database", "")

    logger.info(f"Initializing Neo4j graph connection to {url} (database: {database})")

    return Neo4jGraph(
        url=url,
        username=username,
        password=password,
        database=database
    )

def get_agent_graph():
    """Returns a fresh Neo4jGraph instance using the agent configuration."""
    neo4j_config = config.get("neo4j_agent", {})

    # Extract connection details
    url = neo4j_config.get("uri", "")
    username = neo4j_config.get("username", "")
    password = neo4j_config.get("password", "")
    database = neo4j_config.get("database", "")

    logger.info(f"Initializing Neo4j graph connection to {url} (database: {database})")

    return Neo4jGraph(
        url=url,
        username=username,
        password=password,
        database=database
    )