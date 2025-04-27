# tools/live_feedback.py
# Enhanced version with LangGraph-specific feedback
import streamlit as st
from typing import List, Dict, Any
from datetime import datetime
import threading
import queue
import logging

logger = logging.getLogger(__name__)


class LiveFeedback:
    """Singleton class to handle live feedback across the multi-agent system"""

    _instance = None
    _lock = threading.Lock()

    def __new__(cls):
        with cls._lock:
            if cls._instance is None:
                cls._instance = super(LiveFeedback, cls).__new__(cls)
                cls._instance._initialized = False
            return cls._instance

    def __init__(self):
        if self._initialized:
            return

        self._initialized = True
        self.feedback_queue = queue.Queue()
        self.feedback_history = []
        self.max_history = 100
        self.start_time = datetime.now()

        # LangGraph-specific tracking
        self.tool_calls = []
        self.reasoning_steps = []

    def send(self, message: str, agent: str = None, level: str = "info", step_type: str = None):
        """Send feedback to the UI with enhanced LangGraph support"""
        timestamp = datetime.now()
        feedback_item = {
            "timestamp": timestamp.isoformat(),
            "elapsed": (timestamp - self.start_time).total_seconds(),
            "agent": agent,
            "message": message,
            "level": level,
            "step_type": step_type  # New field for LangGraph steps
        }

        self.feedback_queue.put(feedback_item)
        self.feedback_history.append(feedback_item)

        # Track specific types of steps
        if step_type == "tool_call":
            self.tool_calls.append(feedback_item)
        elif step_type == "reasoning":
            self.reasoning_steps.append(feedback_item)

        # Trim history if needed
        if len(self.feedback_history) > self.max_history:
            self.feedback_history = self.feedback_history[-self.max_history:]

        logger.info(f"Feedback: [{agent}] {message}")

    def get_latest(self, count: int = 10) -> List[Dict[str, Any]]:
        """Get the latest feedback items"""
        items = []
        while not self.feedback_queue.empty() and len(items) < count:
            try:
                item = self.feedback_queue.get_nowait()
                items.append(item)
            except queue.Empty:
                break
        return items

    def get_all(self) -> List[Dict[str, Any]]:
        """Get all feedback history"""
        return self.feedback_history.copy()

    def get_tool_calls(self) -> List[Dict[str, Any]]:
        """Get all tool call feedback"""
        return self.tool_calls.copy()

    def get_reasoning_steps(self) -> List[Dict[str, Any]]:
        """Get all reasoning step feedback"""
        return self.reasoning_steps.copy()

    def clear(self):
        """Clear feedback history"""
        self.feedback_history.clear()
        self.tool_calls.clear()
        self.reasoning_steps.clear()
        while not self.feedback_queue.empty():
            try:
                self.feedback_queue.get_nowait()
            except queue.Empty:
                break

    def reset_timer(self):
        """Reset the start time for elapsed time calculations"""
        self.start_time = datetime.now()


class FeedbackDisplay:
    """Helper class to display feedback in Streamlit"""

    @staticmethod
    def display_feedback_panel(feedback: LiveFeedback, container=None):
        """Display feedback panel in Streamlit with LangGraph enhancements"""
        if container is None:
            container = st.container()

        with container:
            st.markdown("### 🔄 System Activity")

            # Get latest feedback
            latest_items = feedback.get_latest(10)

            if latest_items:
                for item in reversed(latest_items):
                    agent = item.get("agent", "System")
                    elapsed = item.get("elapsed", 0)
                    message = item.get("message", "")
                    level = item.get("level", "info")
                    step_type = item.get("step_type", "general")

                    # Format based on step type
                    if step_type == "tool_call":
                        style_class = "tool-call"
                        icon = "🛠️"
                    elif step_type == "reasoning":
                        style_class = "langgraph-step"
                        icon = "🧠"
                    else:
                        style_class = ""
                        # Level-based icons
                        if level == "error":
                            icon = "❌"
                        elif level == "warning":
                            icon = "⚠️"
                        elif level == "success":
                            icon = "✅"
                        else:
                            icon = "ℹ️"

                    # Choose color based on level
                    if level == "error":
                        color = "red"
                    elif level == "warning":
                        color = "orange"
                    elif level == "success":
                        color = "green"
                    else:
                        color = "blue"

                    st.markdown(
                        f'<div class="{style_class}" style="border-left: 3px solid {color}; padding: 5px; margin: 5px 0;">'
                        f'<small style="color: gray;">[{elapsed:.1f}s] {agent}</small><br>'
                        f'{icon} {message}'
                        f'</div>',
                        unsafe_allow_html=True
                    )
            else:
                st.info("No activity yet...")

    @staticmethod
    def create_activity_timeline(feedback: LiveFeedback):
        """Create a visual timeline of activities with LangGraph insights"""
        history = feedback.get_all()

        if not history:
            st.info("No activity recorded")
            return

        # Create timeline visualization
        st.markdown("### 📊 Activity Timeline")

        # Show LangGraph-specific metrics
        col1, col2, col3 = st.columns(3)
        with col1:
            st.metric("Total Steps", len(history))
        with col2:
            st.metric("Tool Calls", len(feedback.get_tool_calls()))
        with col3:
            st.metric("Reasoning Steps", len(feedback.get_reasoning_steps()))

        # Group by agent
        agents = {}
        for item in history:
            agent = item.get("agent", "System")
            if agent not in agents:
                agents[agent] = []
            agents[agent].append(item)

        # Create a simple timeline chart
        for agent, items in agents.items():
            st.markdown(f"**{agent}**")

            times = [item["elapsed"] for item in items]
            if times:
                min_time = min(times)
                max_time = max(times)

                # Create timeline
                for item in items:
                    elapsed = item["elapsed"]
                    step_type = item.get("step_type", "general")

                    if max_time > min_time:
                        normalized = (elapsed - min_time) / (max_time - min_time)
                    else:
                        normalized = 0

                    bar_length = int(normalized * 50)
                    bar = "█" * bar_length + "░" * (50 - bar_length)

                    # Add step type indicator
                    if step_type == "tool_call":
                        indicator = "🛠️"
                    elif step_type == "reasoning":
                        indicator = "🧠"
                    else:
                        indicator = "•"

                    message = item["message"][:50] + "..." if len(item["message"]) > 50 else item["message"]
                    st.text(f"{elapsed:.1f}s {indicator} |{bar}| {message}")

            st.markdown("---")


# Factory function for global feedback access
def get_feedback() -> LiveFeedback:
    """Get the global feedback instance"""
    return LiveFeedback()