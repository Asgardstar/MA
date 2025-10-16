from langchain_neo4j import Neo4jGraph
import logging
import os

from dotenv import load_dotenv
load_dotenv()

logger = logging.getLogger(__name__)


def get_graph():
    
        # Extract connection details
    url = os.getenv("NEO4J_URL")
    username = os.getenv("NEO4J_ADMIN_USERNAME")
    password = os.getenv("NEO4J_ADMIN_PASSWORD")
    database = os.getenv("NEO4J_DATABASE")

    logger.info(f"Initializing Neo4j graph connection to {url} (database: {database})")

    return Neo4jGraph(
        url=url,
        username=username,
        password=password,
        database=database
    )

def get_agent_graph():

    # Extract connection details
    url = os.getenv("NEO4J_URL")
    username = os.getenv("NEO4J_ADMIN_USERNAME")
    password = os.getenv("NEO4J_ADMIN_PASSWORD")
    database = os.getenv("NEO4J_DATABASE")

    logger.info(f"Initializing Neo4j graph connection to {url} (database: {database})")

    return Neo4jGraph(
        url=url,
        username=username,
        password=password,
        database=database
    )