# simulation_agent_tests/test_string_tool_input.py

import logging
import json
import os
import sys

from pydantic import ValidationError # 确保导入

# --- Path Setup ---
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

from langchain_core.tools import tool
from langchain.agents import AgentExecutor, create_react_agent
from langchain_core.prompts import PromptTemplate
from models.llm import get_llm # 假设 SimulationAgent 和这个脚本用同一个LLM配置
from models.simulation_schemas import ExecutionPayload # 导入Pydantic模型

# --- Logging ---
logging.basicConfig(
    level=logging.INFO, # 可以设为DEBUG看详细过程
    format='%(asctime)s - %(levelname)s - %(name)s - %(module)s.%(funcName)s - %(message)s',
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger(__name__)

# --- 极简工具定义 ---
@tool
def simple_string_processor_tool(json_string_input: str) -> dict:
    """
    This tool expects a single argument 'json_string_input'.
    This argument MUST be a valid JSON string representing an object with
    'simulations' (a list) and 'confirmed' (a boolean) keys.
    For example: '{"simulations": [{"model_id": "m1", "inputs": {}}], "confirmed": false}'
    The tool will attempt to parse this string and validate it against ExecutionPayload.
    """
    logger.info(f"[simple_string_processor_tool] Received raw input: '{json_string_input}'")
    logger.info(f"[simple_string_processor_tool] Type of raw input: {type(json_string_input)}")
    payload_dict = None
    try:
        payload_dict = json.loads(json_string_input)
        logger.info(f"[simple_string_processor_tool] Successfully parsed to dict: {payload_dict}")

        payload_obj = ExecutionPayload.model_validate(payload_dict)
        logger.info(f"[simple_string_processor_tool] Successfully validated with ExecutionPayload: {payload_obj}")
        # 在这个测试工具里，我们不实际调用 execute_single_simulation
        # 只是返回成功信息和解析后的数据
        return {"status": "success_in_tool", "parsed_and_validated_payload": payload_obj.model_dump()}

    except json.JSONDecodeError as e:
        logger.error(f"[simple_string_processor_tool] JSONDecodeError: {e}. Input: '{json_string_input}'")
        return {"status": "error", "message": f"Invalid JSON string: {e}"}
    except ValidationError as e:
        errors = e.errors()
        logger.error(f"[simple_string_processor_tool] Pydantic ValidationError: {json.dumps(errors, indent=2)}. Input: '{json_string_input}', Parsed dict: {payload_dict}")
        return {"status": "pydantic_validation_error_in_tool", "errors": errors}
    except Exception as e:
        logger.error(f"[simple_string_processor_tool] Unexpected Exception: {type(e).__name__} - {e}. Input: '{json_string_input}'", exc_info=True)
        return {"status": "error", "message": f"Unexpected error in tool: {e}"}

# --- 极简Agent提示 ---
MINIMAL_PROMPT_TEMPLATE = """
You have access to the following tools and their descriptions:
{tools} 

The available tool names are: {tool_names} 

Use the following format:
Thought: [Your thought process]
Action: [The tool to use. This MUST be one of the names from {tool_names}]
Action Input: [The input to the action. For 'simple_string_processor_tool', this MUST be a JSON string.]
Observation: [Result from the tool]
Thought: I have the result.
Final Answer: [The result from the tool, or a summary]

Your task is to call the 'simple_string_processor_tool'.
The JSON string content for its 'json_string_input' argument should be: {{"simulations": [{{"model_id": "test_model", "inputs": {{"voltage": 100}} }}], "confirmed": false}}

Begin!

Input: {input}
{agent_scratchpad}
"""

MINIMAL_PROMPT = PromptTemplate.from_template(MINIMAL_PROMPT_TEMPLATE)

def main():
    logger.info("--- Starting Minimal Pydantic Tool Input Test with Agent ---")

    # 1. 获取LLM实例
    try:
        llm = get_llm("simulationagent") # 使用与SimulationAgent相同的LLM配置
    except Exception as e:
        logger.error(f"Failed to get LLM: {e}", exc_info=True)
        return

    # 2. 定义工具列表
    tools = [simple_string_processor_tool]

    # 3. 创建极简Agent
    try:
        agent = create_react_agent(llm, tools, MINIMAL_PROMPT)
        agent_executor = AgentExecutor(
            agent=agent,
            tools=tools,
            verbose=True,
            handle_parsing_errors=True,
            max_iterations=3 # 应该只需要一次工具调用
        )
        logger.info("Minimal agent created successfully.")
    except Exception as e:
        logger.error(f"Failed to create minimal agent: {e}", exc_info=True)
        return

    # 4. 调用Agent
    try:
        # 对于这个简单任务，我们不需要复杂的聊天历史或上下文
        response = agent_executor.invoke({"input": "Call the tool as instructed."})
        logger.info("\n--- Agent Invocation Result ---")
        logger.info(f"Final output: {response.get('output')}")

    except Exception as e:
        logger.error(f"Error during agent invocation: {type(e).__name__} - {e}", exc_info=True)
        # 如果这里捕获到 Pydantic ValidationError，说明问题仍在 AgentExecutor/Tool.run() 层
        if isinstance(e, ValidationError):
            logger.error(f"Captured Pydantic ValidationError at AgentExecutor level: {json.dumps(e.errors(), indent=2)}")


    logger.info("--- Minimal Pydantic Tool Input Test with Agent Finished ---")

if __name__ == "__main__":
    # 确保.env文件被加载 (如果 get_llm 依赖它)
    from dotenv import load_dotenv
    dotenv_path = os.path.join(PROJECT_ROOT, '.env')
    if os.path.exists(dotenv_path):
        load_dotenv(dotenv_path)
    else:
        logger.warning(f".env file not found at {dotenv_path}. Ensure API keys and other secrets are set.")
    main()