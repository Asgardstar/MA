"""
Simple test to verify LangGraph is working correctly
"""
from langgraph.graph import StateGraph, START, END
from langgraph.checkpoint.memory import MemorySaver
from langchain_core.messages import HumanMessage, AIMessage
import uuid


# Define a simple state type
class SimpleState(dict):
    """Simple state dictionary"""
    pass


def test_node(state: SimpleState):
    """Simple test node that adds a message"""
    print("Test node called")
    print(f"Input state: {state}")

    # Add a message to the state
    if "messages" not in state:
        state["messages"] = []

    # Add a response message
    messages = state["messages"] + [AIMessage(content="This is a test response")]

    print(f"Returning messages: {messages}")
    return {"messages": messages, "processed": True}


def main():
    # Create a simple graph
    builder = StateGraph(SimpleState)

    # Add a single node
    builder.add_node("test", test_node)

    # Add edges
    builder.add_edge(START, "test")
    builder.add_edge("test", END)

    # Set up memory
    memory = MemorySaver()

    # Compile the graph
    graph = builder.compile(checkpointer=memory)

    # Create a session ID
    session_id = str(uuid.uuid4())
    print(f"Testing with session ID: {session_id}")

    # Create initial state
    initial_state = {
        "messages": [HumanMessage(content="Test input")]
    }

    # Create config
    config = {
        "configurable": {
            "thread_id": session_id
        }
    }

    # Run the graph
    result = graph.invoke(initial_state, config)

    # Print the result
    print(f"Result: {result}")

    # Try to get state history
    try:
        history = graph.get_state_history(config)
        print(f"History count: {len(history)}")
        for i, checkpoint in enumerate(history):
            print(f"Checkpoint {i}: {checkpoint}")
    except Exception as e:
        print(f"Error getting history: {e}")


if __name__ == "__main__":
    main()