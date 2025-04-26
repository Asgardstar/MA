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

    def send(self, message: str, agent: str = None, level: str = "info"):
        """Send feedback to the UI"""
        timestamp = datetime.now()
        feedback_item = {
            "timestamp": timestamp.isoformat(),
            "elapsed": (timestamp - self.start_time).total_seconds(),
            "agent": agent,
            "message": message,
            "level": level
        }

        self.feedback_queue.put(feedback_item)
        self.feedback_history.append(feedback_item)

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

    def clear(self):
        """Clear feedback history"""
        self.feedback_history.clear()
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
        """Display feedback panel in Streamlit"""
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

                    # Format the message with color based on level
                    if level == "error":
                        color = "red"
                        icon = "❌"
                    elif level == "warning":
                        color = "orange"
                        icon = "⚠️"
                    elif level == "success":
                        color = "green"
                        icon = "✅"
                    else:
                        color = "blue"
                        icon = "ℹ️"

                    st.markdown(
                        f'<div style="padding: 5px; border-left: 3px solid {color}; margin: 5px 0;">'
                        f'<small style="color: gray;">[{elapsed:.1f}s] {agent}</small><br>'
                        f'{icon} {message}'
                        f'</div>',
                        unsafe_allow_html=True
                    )
            else:
                st.info("No activity yet...")

    @staticmethod
    def create_activity_timeline(feedback: LiveFeedback):
        """Create a visual timeline of activities"""
        history = feedback.get_all()

        if not history:
            st.info("No activity recorded")
            return

        # Create timeline visualization
        st.markdown("### 📊 Activity Timeline")

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

            # Create a simple progress bar for each agent's activities
            times = [item["elapsed"] for item in items]
            if times:
                min_time = min(times)
                max_time = max(times)

                # Create a simple timeline visualization
                timeline_data = []
                for item in items:
                    elapsed = item["elapsed"]
                    normalized = (elapsed - min_time) / (max_time - min_time) if max_time > min_time else 0
                    timeline_data.append({
                        "time": elapsed,
                        "position": normalized,
                        "message": item["message"][:30] + "..." if len(item["message"]) > 30 else item["message"]
                    })

                # Simple text-based timeline
                for data in timeline_data:
                    bar_length = int(data["position"] * 50)
                    bar = "█" * bar_length + "░" * (50 - bar_length)
                    st.text(f"{data['time']:.1f}s |{bar}| {data['message']}")

            st.markdown("---")


# Factory function for global feedback access
def get_feedback() -> LiveFeedback:
    """Get the global feedback instance"""
    return LiveFeedback()