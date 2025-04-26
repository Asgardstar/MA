from sentence_transformers import SentenceTransformer
import neo4j
from neo4j import Query
from utils.utils import load_config
import os

# Load configuration
NEO4J_ADMIN = os.getenv('NEO4J_ADMIN')

# Database connection credentials
config = load_config()
neo4j_config = config.get("neo4j", {})
uri = neo4j_config.get("uri", "")
auth = (neo4j_config.get("username", ""), NEO4J_ADMIN)
db_name = neo4j_config.get("database", "")

# Get embedding configuration
embedding_config = config.get("embedding", {})
model_name = embedding_config.get("model", "all-MiniLM-L6-v2")
batch_size = embedding_config.get("batch_size", 32)
dimension = embedding_config.get("dimension", 384)


def main():
    driver = neo4j.GraphDatabase.driver(uri, auth=auth)
    driver.verify_connectivity()

    # Initialize the sentence transformer model from config
    model = SentenceTransformer(model_name)

    batch_n = 1
    nodes_with_embeddings = []

    with driver.session(database=db_name) as session:
        # Find nodes with description property
        result = session.run(
            'MATCH (n) WHERE n.description IS NOT NULL RETURN elementId(n) as elementId, n.description AS description, n.name AS name')
        for record in result:
            node_id = record.get('elementId')
            name = record.get('name')
            description = record.get('description')

            # Create embedding
            if description is not None:
                text_to_encode = f"Name: {name or ''}\nDescription: {description}"
                embedding = model.encode(text_to_encode).tolist()
                nodes_with_embeddings.append({
                    'elementId': node_id,
                    'name': name,
                    'description': description,
                    'embedding': embedding
                })

            # Import when a batch has embeddings ready; flush buffer
            if len(nodes_with_embeddings) == batch_size:
                import_batch(driver, nodes_with_embeddings, batch_n)
                nodes_with_embeddings = []
                batch_n += 1

        # Flush last batch
        if nodes_with_embeddings:
            import_batch(driver, nodes_with_embeddings, batch_n)

    # Create vector index if it doesn't exist
    try:
        vector_query = Query('''
        CREATE VECTOR INDEX IF NOT EXISTS nodeDescription
        FOR (n:node)
        ON n.description_embedding
        OPTIONS {indexConfig: {
            `vector.dimensions`: $dimension,
            `vector.similarity_function`: 'cosine'
        }}
        ''')

        driver.execute_query(
            vector_query,
            parameters={"dimension": dimension},
            database_=db_name
        )
        print("Vector index created or already exists.")
    except Exception as e:
        print(f"Error creating vector index: {e}")

    # Import complete, show counters
    records, _, _ = driver.execute_query(
        Query(
            'MATCH (n WHERE n.description_embedding IS NOT NULL) RETURN count(*) AS countNodesWithEmbeddings, size(n.description_embedding) AS embeddingSize'),
        database_=db_name
    )

    print(f"""
Embeddings generated and attached to nodes.
Nodes with embeddings: {records[0].get('countNodesWithEmbeddings')}.
Embedding size: {records[0].get('embeddingSize')}.
    """)


def import_batch(driver, nodes_with_embeddings, batch_n):
    # Add embeddings to nodes
    update_query = Query('''
    UNWIND $nodes AS node
    MATCH (n) WHERE elementId(n) = node.elementId
    SET n.description_embedding = node.embedding
    ''')

    driver.execute_query(
        update_query,
        parameters={"nodes": nodes_with_embeddings},
        database_=db_name
    )

    print(f'Processed batch {batch_n} with {len(nodes_with_embeddings)} nodes.')


if __name__ == '__main__':
    main()