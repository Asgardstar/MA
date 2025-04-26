from typing import TypedDict, Annotated, Sequence, Union, List, Dict, Any
from langgraph.graph import StateGraph, END
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
import logging

from utils.utils import get_session_id
from agents.supervisor import SupervisorAgent
from agents.search_agent import SearchAgent
from agents.simulation_agent import SimulationAgent
from tools.live_feedback import LiveFeedback

logger = logging.getLogger(__name__)


class AgentState(TypedDict):
    messages: Sequence[BaseMessage]
    next: str
    current_agent: str
    query: str
    search_results: Dict[str, Any]
    simulation_results: Dict[str, Any]
    final_answer: str
    formatted_answer: str
    feedback: List[Dict[str, Any]]
    error: str
    session_id: str
    intermediate_steps: List[Any]


class MultiAgentSystem:
    def __init__(self):
        self.feedback = LiveFeedback()
        self.supervisor = SupervisorAgent()
        self.search_agent = SearchAgent()
        self.simulation_agent = SimulationAgent()
        self.workflow = self._create_workflow()

    def _create_workflow(self) -> StateGraph:
        workflow = StateGraph(AgentState)

        # Add nodes
        workflow.add_node("supervisor", self.supervisor_node)
        workflow.add_node("search_agent", self.search_agent_node)
        workflow.add_node("simulation_agent", self.simulation_agent_node)
        workflow.add_node("feedback", self.feedback_node)

        # Set entry point
        workflow.set_entry_point("supervisor")

        # Define transitions
        workflow.add_conditional_edges(
            "supervisor",
            self.route_supervisor,
            {
                "search_agent": "search_agent",
                "simulation_agent": "simulation_agent",
                "END": END
            }
        )

        # Connect agents back to supervisor
        workflow.add_edge("search_agent", "supervisor")
        workflow.add_edge("simulation_agent", "supervisor")

        # Add feedback edges
        workflow.add_edge("supervisor", "feedback")
        workflow.add_edge("search_agent", "feedback")
        workflow.add_edge("simulation_agent", "feedback")
        workflow.add_edge("feedback", "supervisor")

        return workflow.compile()

    def route_supervisor(self, state: AgentState) -> str:
        """Route based on supervisor's decision"""
        next_action = state.get("next", "END")
        logger.info(f"Supervisor routing to: {next_action}")
        return next_action

    def supervisor_node(self, state: AgentState) -> AgentState:
        """Supervisor node logic"""
        logger.info("Supervisor processing...")
        self.feedback.send("🤔 Analyzing your request...")

        try:
            # Process the current state and decide next action
            result = self.supervisor.process(state)
            state.update(result)

            # Provide feedback based on the decision
            if state.get("next") == "search_agent":
                self.feedback.send("🔍 Searching knowledge graph for relevant information...")
            elif state.get("next") == "simulation_agent":
                self.feedback.send("⚙️ Processing simulation request...")
            elif state.get("next") == "END":
                self.feedback.send("✅ Finalizing response...")

            return state
        except Exception as e:
            logger.error(f"Error in supervisor: {str(e)}")
            state["error"] = str(e)
            state["next"] = "END"
            state["formatted_answer"] = self.supervisor._format_error_message(str(e))
            return state

    def search_agent_node(self, state: AgentState) -> AgentState:
        """Search agent node logic"""
        logger.info("Search agent processing...")
        self.feedback.send("🔎 Querying the knowledge graph...")

        try:
            result = self.search_agent.process(state)
            state.update(result)

            if result.get("search_results"):
                self.feedback.send("📊 Found relevant information")
            else:
                self.feedback.send("ℹ️ No relevant information found")

            return state
        except Exception as e:
            logger.error(f"Error in search agent: {str(e)}")
            state["error"] = str(e)
            return state

    def simulation_agent_node(self, state: AgentState) -> AgentState:
        """Simulation agent node logic"""
        logger.info("Simulation agent processing...")
        self.feedback.send("🧮 Analyzing simulation requirements...")

        try:
            result = self.simulation_agent.process(state)
            state.update(result)

            if result.get("simulation_results"):
                self.feedback.send("✨ Simulation completed successfully")
            else:
                self.feedback.send("📋 Simulation analysis completed")

            return state
        except Exception as e:
            logger.error(f"Error in simulation agent: {str(e)}")
            state["error"] = str(e)
            return state

    def feedback_node(self, state: AgentState) -> AgentState:
        """Process and collect feedback"""
        # This node just ensures feedback is tracked in state
        if "feedback" not in state:
            state["feedback"] = []

        # Add latest feedback to state
        latest_feedback = self.feedback.get_latest()
        if latest_feedback:
            state["feedback"].extend(latest_feedback)

        return state

    def run(self, query: str, session_id: str = None) -> Dict[str, Any]:
        """Run the multi-agent system"""
        if not session_id:
            session_id = get_session_id()

        initial_state = {
            "messages": [HumanMessage(content=query)],
            "query": query,
            "current_agent": "supervisor",
            "session_id": session_id,
            "feedback": [],
            "intermediate_steps": []
        }

        try:
            self.feedback.send(f"🚀 Processing query: {query}")
            result = self.workflow.invoke(initial_state)

            # Get the final formatted answer from the supervisor
            final_response = result.get("formatted_answer", result.get("final_answer", "No response generated"))

            return {
                "response": final_response,
                "feedback": result.get("feedback", []),
                "search_results": result.get("search_results"),
                "simulation_results": result.get("simulation_results"),
                "error": result.get("error")
            }
        except Exception as e:
            logger.error(f"Error in multi-agent system: {str(e)}")
            return {
                "response": self.supervisor._format_error_message(str(e)),
                "feedback": self.feedback.get_all(),
                "error": str(e)
            }


# Factory function
def create_multi_agent_system() -> MultiAgentSystem:
    """Create and return a configured multi-agent system"""
    return MultiAgentSystem()