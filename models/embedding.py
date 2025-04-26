from utils.utils import load_config
import logging

logger = logging.getLogger(__name__)

# Get the configuration
config = load_config()
embedding_config = config.get("embedding", {})
dimension = embedding_config.get("dimension", {})

# Initialize the embedding model based on configuration
provider = embedding_config.get("provider", "sentence_transformers")
model_name = embedding_config.get("model", "all-MiniLM-L6-v2")

logger.info(f"Initializing embedding model: {provider}/{model_name}")

if provider == "sentence_transformers":
    from sentence_transformers import SentenceTransformer

    embedding_model = SentenceTransformer(model_name)

else:
    logger.error(f"Unsupported embedding provider: {provider}")
    raise ValueError(f"Unsupported embedding provider: {provider}")


# Create a wrapper class to adapt embedding model to LangChain's expected interface
class Embeddings:
    def __init__(self, model, normalize_embeddings=True):
        self.model = model
        self.normalize_embeddings = normalize_embeddings

    def embed_query(self, text):
        if hasattr(self.model, 'encode'):
            # For SentenceTransformer models
            return self.model.encode(text, normalize_embeddings=self.normalize_embeddings)
        else:
            # For LangChain compatible models
            return self.model.embed_query(text)

    def embed_documents(self, documents):
        if hasattr(self.model, 'encode'):
            # For SentenceTransformer models
            return self.model.encode(documents, normalize_embeddings=self.normalize_embeddings)
        else:
            # For LangChain compatible models
            return self.model.embed_documents(documents)


# Wrap the embedding model
embeddings_wrapper = Embeddings(embedding_model)


# Function to get the embedding model directly
def get_embedding_model():
    return embedding_model


# Function to get the wrapped embedding model
def get_embeddings():
    return embeddings_wrapper