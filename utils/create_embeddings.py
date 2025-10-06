from dotenv import load_dotenv
load_dotenv()
import os
from sentence_transformers import SentenceTransformer
import neo4j
from neo4j import Query
from utils import load_config

# Load configuration
config = load_config()
uri = os.getenv("NEO4J_URL")
auth = (os.getenv("NEO4J_ADMIN_USERNAME"), os.getenv("NEO4J_ADMIN_PASSWORD"))
db_name = os.getenv("NEO4J_DATABASE")

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
        # Run a single query to fetch all relevant node data
        result = session.run('MATCH (n) RETURN elementId(n) as elementId, n.name AS name, n.description AS description')
        print(result)

        nodes_with_embeddings = []

        for record in result:
            node_id = record.get('elementId')
            name = record.get('name') or ''
            description = record.get('description')

            # Choose text to encode
            if description:
                text_to_encode = f"Name: {name}\nDescription: {description}"
            else:
                text_to_encode = f"Name: {name}"

            # Create embedding
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
        nodes = nodes_with_embeddings,
        database_=db_name
    )

    print(f'Processed batch {batch_n} with {len(nodes_with_embeddings)} nodes.')


if __name__ == '__main__':
    main()