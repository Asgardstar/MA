from dotenv import load_dotenv

load_dotenv()
import os
import neo4j
from neo4j import Query
from utils import load_config

# Database connection credentials
config = load_config()
neo4j_config = config.get("neo4j", {})
uri = os.getenv("NEO4J_URL")
auth = (os.getenv("NEO4J_ADMIN_USERNAME"), os.getenv("NEO4J_ADMIN_PASSWORD"))
db_name = os.getenv("NEO4J_DATABASE")

embedding_config = config.get("embedding", {})
dimension = embedding_config.get("dimension", {})


def delete_vector_index():
    """Delete existing vector index if it exists"""
    driver = neo4j.GraphDatabase.driver(uri, auth=auth)
    driver.verify_connectivity()

    print("Checking and deleting existing vector index...")

    try:
        # Delete vector index if it exists
        delete_query = Query('DROP INDEX $indexname IF EXISTS')

        driver.execute_query(
            delete_query,
            indexname=f"embedding_{dimension}",
            database_=db_name
        )
        print(f"Vector index 'embedding_{dimension}' deleted successfully (if it existed).")

    except Exception as e:
        print(f"Error deleting vector index: {e}")

    finally:
        driver.close()


def create_vector_index():
    """Create new vector index"""
    driver = neo4j.GraphDatabase.driver(uri, auth=auth)
    driver.verify_connectivity()

    print("Creating vector index...")

    try:
        # Create vector index with proper parameter passing
        vector_query = Query('''
        CREATE VECTOR INDEX $indexname
        FOR (n:node)
        ON n.description_embedding
        OPTIONS {indexConfig: {
            `vector.dimensions`: $dimension,
            `vector.similarity_function`: 'cosine'
        }}
        ''')

        driver.execute_query(
            vector_query,
            indexname=f"embedding_{dimension}",
            dimension=dimension,
            database_=db_name
        )
        print("Vector index created successfully.")

    except Exception as e:
        print(f"Error creating vector index: {e}")

    finally:
        driver.close()


def recreate_vector_index():
    """Delete existing index and create a new one"""
    print("=== Recreating Vector Index ===")
    delete_vector_index()
    create_vector_index()
    print("=== Vector Index Recreation Complete ===")


if __name__ == "__main__":
    recreate_vector_index()