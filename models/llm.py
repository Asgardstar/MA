from utils.utils import load_config
import logging
from dotenv import load_dotenv
from langchain_google_genai import ChatGoogleGenerativeAI

load_dotenv()
logger = logging.getLogger(__name__)

# Get the configuration
config = load_config()


def get_llm(agent):
    """Get LLM instance for a specific agent"""
    # Construct the config key based on agent name
    config_key = f"llm_{agent}" if agent in ["supervisor", "searchagent", "simulationagent"] else None

    if not config_key or config_key not in config:
        raise ValueError(f"Invalid agent type: {agent}")

    agent_config = config.get(config_key, {})

    return ChatGoogleGenerativeAI(
        model=agent_config.get("model", "gemini-2.0-flash"),
        temperature=agent_config.get("temperature", 0),
        max_tokens=agent_config.get("max_tokens", None),
        max_retries=2,
    )