import streamlit as st
from streamlit.runtime.scriptrunner import get_script_run_ctx
import json

def write_message(role, content, save = True):
    """
    This is a helper function that saves a message to the
     session state and then writes a message to the UI
    """
    # Append to session state
    if save:
        st.session_state.messages.append({"role": role, "content": content})

    # Write to UI
    with st.chat_message(role):
        st.markdown(content)

def get_session_id():
    return get_script_run_ctx().session_id

def load_config():
    with open('config.json', 'r') as config_file:
        return json.load(config_file)