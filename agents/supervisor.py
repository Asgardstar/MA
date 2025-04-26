from typing import Dict, Any
from langchain.agents import create_react_agent
from langchain_core.messages import HumanMessage, AIMessage
from models.llm import get_llm
from prompts.supervisor_prompt import SUPERVISOR_PROMPT
import logging

logger = logging.getLogger(__name__)


class SupervisorAgent:
    def __init__(self):

        # Initialize LLM specifically for supervisor
        self.llm = get_llm("supervisor")
        self.agent = self._create_agent()

    def _create_agent(self):
        """Create the supervisor agent"""
        return create_react_agent(
            llm=self.llm,
            prompt=SUPERVISOR_PROMPT
        )

    def process(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Process the state and make routing decisions"""
        query = state.get("query", "")
        messages = state.get("messages", [])
        search_results = state.get("search_results")
        simulation_results = state.get("simulation_results")
        current_agent = state.get("current_agent", "supervisor")

        # Create context for the supervisor
        context = self._build_context(state)

        # Create prompt for the supervisor
        prompt = self._create_prompt(query, context)

        try:
            # Get supervisor decision
            response = self.llm.invoke(prompt)
            content = response.content

            # Parse the decision
            decision = self._parse_decision(content)

            # Update state with supervisor's decision
            state["next"] = decision["next_agent"]
            state["messages"].append(AIMessage(content=f"Supervisor: {decision['reasoning']}"))

            # If there's a user message, add it
            if decision.get("user_message"):
                state["messages"].append(AIMessage(content=decision["user_message"]))

            # If this is the final answer, format it properly
            if decision.get("final_answer"):
                state["final_answer"] = decision["final_answer"]
                state["formatted_answer"] = self._format_final_answer(decision["final_answer"], state)

            logger.info(f"Supervisor decision: {decision}")

            return state

        except Exception as e:
            logger.error(f"Error in supervisor processing: {str(e)}")
            state["error"] = str(e)
            state["next"] = "END"
            state["formatted_answer"] = self._format_error_message(str(e))
            return state

    def _build_context(self, state: Dict[str, Any]) -> str:
        """Build context from the current state"""
        context_parts = []

        if state.get("search_results"):
            context_parts.append("SEARCH RESULTS:")
            context_parts.append(self._format_search_results(state["search_results"]))

        if state.get("simulation_results"):
            context_parts.append("SIMULATION RESULTS:")
            context_parts.append(self._format_simulation_results(state["simulation_results"]))

        if state.get("error"):
            context_parts.append(f"ERROR: {state['error']}")

        # Add conversation history
        messages = state.get("messages", [])
        if messages:
            history = []
            for msg in messages[-5:]:  # Last 5 messages for context
                if isinstance(msg, HumanMessage):
                    history.append(f"Human: {msg.content}")
                elif isinstance(msg, AIMessage):
                    history.append(f"AI: {msg.content}")
            context_parts.append("RECENT CONVERSATION:\n" + "\n".join(history))

        return "\n\n".join(context_parts)

    def _format_search_results(self, results: Dict[str, Any]) -> str:
        """Format search results for context"""
        if not results:
            return "No search results available."

        formatted = []
        if results.get("summary"):
            formatted.append(f"Summary: {results['summary']}")

        if results.get("findings"):
            formatted.append("Findings:")
            for finding in results["findings"]:
                formatted.append(f"- {finding.get('result', '')}")

        return "\n".join(formatted)

    def _format_simulation_results(self, results: Dict[str, Any]) -> str:
        """Format simulation results for context"""
        if not results:
            return "No simulation results available."

        formatted = []
        if results.get("summary"):
            formatted.append(f"Summary: {results['summary']}")

        if results.get("executions"):
            formatted.append("Executions:")
            for execution in results["executions"]:
                formatted.append(f"- {execution.get('type', '')}: {execution.get('result', '')}")

        return "\n".join(formatted)

    def _create_prompt(self, query: str, context: str) -> str:
        """Create prompt for the supervisor"""
        return f"""
        Query: {query}

        Current Context:
        {context}

        Based on the query and current context, decide which agent should handle this next:
        - search_agent: For searching the knowledge graph for information
        - simulation_agent: For simulation-related tasks
        - END: If the task is complete

        Provide your decision in the following format:
        DECISION: [agent_name]
        REASONING: [your reasoning]
        USER_MESSAGE: [message to the user about what's happening]
        FINAL_ANSWER: [if applicable, the final formatted answer to the query]
        """

    def _parse_decision(self, content: str) -> Dict[str, Any]:
        """Parse the supervisor's decision from the response"""
        lines = content.strip().split('\n')
        decision = {
            "next_agent": "END",
            "reasoning": "",
            "user_message": None,
            "final_answer": None
        }

        current_field = None
        current_content = []

        for line in lines:
            if line.startswith("DECISION:"):
                decision["next_agent"] = line.split(":", 1)[1].strip()
            elif line.startswith("REASONING:"):
                decision["reasoning"] = line.split(":", 1)[1].strip()
            elif line.startswith("USER_MESSAGE:"):
                current_field = "user_message"
                current_content = [line.split(":", 1)[1].strip()]
            elif line.startswith("FINAL_ANSWER:"):
                current_field = "final_answer"
                current_content = [line.split(":", 1)[1].strip()]
            elif current_field and line.strip():
                current_content.append(line.strip())

        # Combine multi-line fields
        if current_field == "user_message":
            decision["user_message"] = "\n".join(current_content)
        elif current_field == "final_answer":
            decision["final_answer"] = "\n".join(current_content)

        return decision

    def _format_final_answer(self, answer: str, state: Dict[str, Any]) -> str:
        """Format the final answer with appropriate styling"""
        # The answer should already be formatted by the LLM according to the prompt
        # We can add any additional formatting here if needed
        return answer

    def _format_error_message(self, error: str) -> str:
        """Format error messages for users"""
        return f"""
## ❌ Error Occurred

I encountered an error while processing your request:

```
{error}
```

**What you can do:**
1. Try rephrasing your question
2. Provide more specific details
3. Check if all required information is available

If the problem persists, please contact support.
"""