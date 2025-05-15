from dotenv import load_dotenv

load_dotenv()
import neo4j
from neo4j import Query
from utils.utils import load_config

# Database connection credentials
import os
password = os.getenv("NEO4J_ADMIN")

# Load configuration
config = load_config()
neo4j_config = config.get("neo4j", {})
uri = neo4j_config.get("uri", "")
auth = (neo4j_config.get("username", ""), password)
db_name = neo4j_config.get("database", "")

embedding_config = config.get("embedding", {})
dimension = embedding_config.get("dimension", {})

def create_vector_index():
    driver = neo4j.GraphDatabase.driver(uri, auth=auth)
    driver.verify_connectivity()

    print("Creating vector index...")

    try:
        # Create vector index with proper parameter passing
        vector_query = Query('''
        CREATE VECTOR INDEX nodeDescription
        FOR (n:node)
        ON n.description_embedding
        OPTIONS {indexConfig: {
            `vector.dimensions`: $dimension,
            `vector.similarity_function`: 'cosine'
        }}
        ''')

        driver.execute_query(
            vector_query,
            #parameters={"dimension": dimension},
            dimension = dimension,
            database_=db_name
        )
        print("Vector index created successfully.")

    except Exception as e:
        print(f"Error creating vector index: {e}")

    finally:
        driver.close()


if __name__ == "__main__":
    create_vector_index()