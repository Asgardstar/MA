from dotenv import load_dotenv

load_dotenv()
import streamlit as st
from multi_agent_system import create_langgraph_multi_agent_system
from tools.live_feedback import get_feedback, FeedbackDisplay

# Page Config
st.set_page_config("AI Engineering Crew", layout="wide")

# Initialize the multi-agent system with LangGraph
if "multi_agent_system" not in st.session_state:
    st.session_state.multi_agent_system = create_langgraph_multi_agent_system()

# Initialize feedback system
feedback = get_feedback()

# Set up Session State
if "messages" not in st.session_state:
    st.session_state.messages = [
        {"role": "assistant", "content": "Hi, we are your artificial colleagues! How can we assist you?"},
    ]

# Create layout with main chat and feedback panel
col1, col2 = st.columns([2, 1])

with col1:
    st.markdown("### 💬 Chat")

    # Display messages in Session State
    for message in st.session_state.messages:
        if message['role'] == 'user':
            with st.chat_message('user'):
                st.markdown(message['content'])
        else:
            with st.chat_message('assistant'):
                st.markdown(message['content'])

    # Chat input
    if prompt := st.chat_input("What is up?"):
        # Display user message directly
        with st.chat_message('user'):
            st.markdown(prompt)

        # Add to messages
        st.session_state.messages.append({"role": "user", "content": prompt})

        # Clear previous feedback and reset timer
        feedback.clear()
        feedback.reset_timer()

        # Create container for assistant response
        with st.chat_message("assistant"):
            with st.spinner('Engineering...'):
                try:
                    # Get response from multi-agent system
                    result = st.session_state.multi_agent_system.run(prompt)

                    # Display the response
                    response = result.get("response", "We couldn't process your request. AI won't replace you yet.")
                    st.markdown(response)

                    # Save the response to messages
                    st.session_state.messages.append({"role": "assistant", "content": response})

                    # If there's an error, display it
                    if result.get("error"):
                        st.error(f"Error: {result['error']}")

                except Exception as e:
                    error_message = f"An error occurred: {str(e)}"
                    st.markdown(error_message)
                    st.session_state.messages.append({"role": "assistant", "content": error_message})
                    st.error(error_message)

        # Force a rerun to update the feedback panel
        st.rerun()

with col2:
    # Create a container for feedback that updates
    feedback_container = st.empty()

    # Display feedback
    with feedback_container.container():
        FeedbackDisplay.display_feedback_panel(feedback)

    # Add timeline view
    with st.expander("View Activity Timeline", expanded=False):
        FeedbackDisplay.create_activity_timeline(feedback)

    # Add agent activity monitor specific to LangGraph
    st.markdown("### 🤖 Agent Activity")
    st.markdown("""
    **Current Architecture:**
    - LangGraph ReAct Agent (Supervisor)
    - Search Agent (Tool)
    - Simulation Agent (Tool)
    - Response Formatter (Tool)
    """)

# Add a sidebar with system controls
with st.sidebar:
    st.markdown("### 🎛️ System Controls")

    if st.button("Clear Chat History"):
        st.session_state.messages = [
            {"role": "assistant", "content": "Hi, we are your artificial colleagues! How can we assist you?"},
        ]
        st.rerun()

    if st.button("Clear Feedback"):
        feedback.clear()
        st.rerun()

    st.markdown("### ℹ️ System Info")
    st.markdown("""
    This chatbot uses LangGraph multi-agent system:
    - **Supervisor**: ReAct agent that orchestrates
    - **Search Tool**: Queries knowledge graph
    - **Simulation Tool**: Manages simulations
    - **Formatter Tool**: Formats responses

    The supervisor decides which tools to use based on the query.
    """)

    # Show current configuration
    with st.expander("View Configuration"):
        import json
        from utils.utils import load_config

        config = load_config()
        st.json(config)

    # Add LangGraph-specific monitoring
    with st.expander("LangGraph Status"):
        if st.session_state.get("multi_agent_system"):
            st.markdown("✅ LangGraph system initialized")
            st.markdown("### Available Tools:")
            for tool in st.session_state.multi_agent_system.tools:
                st.markdown(f"- {tool.name}")
        else:
            st.markdown("⚠️ System not initialized")

# Add custom CSS for better styling
st.markdown("""
<style>
    .stChatMessage {
        padding: 1rem;
        border-radius: 0.5rem;
        margin-bottom: 1rem;
    }
    .stSpinner {
        text-align: center;
    }
    div[data-testid="stHorizontalBlock"] {
        gap: 2rem;
    }
    /* LangGraph-specific styling */
    .langgraph-step {
        border-left: 3px solid #4CAF50;
        padding-left: 10px;
        margin: 5px 0;
    }
    .tool-call {
        border-left: 3px solid #2196F3;
        padding-left: 10px;
        margin: 5px 0;
    }
</style>
""", unsafe_allow_html=True)