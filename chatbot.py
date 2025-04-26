from dotenv import load_dotenv
load_dotenv()
import streamlit as st
from utils.utils import write_message
from multi_agent_system import create_multi_agent_system
from tools.live_feedback import get_feedback, FeedbackDisplay
import time

# Page Config
st.set_page_config("AI Engineering Crew", layout="wide")

# Initialize the multi-agent system
if "multi_agent_system" not in st.session_state:
    st.session_state.multi_agent_system = create_multi_agent_system()

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
        write_message(message['role'], message['content'], save=False)

    # Chat input at the bottom
    if prompt := st.chat_input("What is up?"):
        # Display user message
        write_message('user', prompt)

        # Clear previous feedback and reset timer
        feedback.clear()
        feedback.reset_timer()

        # Create placeholder for assistant response
        with st.chat_message("assistant"):
            message_placeholder = st.empty()

            # Run the multi-agent system
            with st.spinner('Engineering...'):
                try:
                    # Get response from multi-agent system
                    result = st.session_state.multi_agent_system.run(prompt)

                    # Display the response
                    response = result.get("response", "We couldn't process your request. AI won't replace you yet.")
                    message_placeholder.markdown(response)

                    # Save the response
                    write_message('assistant', response, save=True)

                    # If there's an error, display it
                    if result.get("error"):
                        st.error(f"Error: {result['error']}")

                except Exception as e:
                    error_message = f"An error occurred: {str(e)}"
                    message_placeholder.markdown(error_message)
                    write_message('assistant', error_message, save=True)
                    st.error(error_message)

with col2:
    # Create a container for feedback that updates
    feedback_container = st.empty()

    # Create a loop to update feedback display
    if st.session_state.get("processing", False):
        while st.session_state.processing:
            with feedback_container.container():
                FeedbackDisplay.display_feedback_panel(feedback)
            time.sleep(0.5)
    else:
        with feedback_container.container():
            FeedbackDisplay.display_feedback_panel(feedback)

    # Add timeline view
    with st.expander("View Activity Timeline", expanded=False):
        FeedbackDisplay.create_activity_timeline(feedback)

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
    This chatbot uses a multi-agent system:
    - **Supervisor**: Routes queries
    - **Search Agent**: Queries knowledge graph
    - **Simulation Agent**: Manages simulations
    - **Response Agent**: Formats responses
    """)

    # Show current configuration
    with st.expander("View Configuration"):
        import json
        from utils.utils import load_config

        config = load_config()
        st.json(config)

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
</style>
""", unsafe_allow_html=True)