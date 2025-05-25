# simulation_agent_tests/test_pydantic_tool_input.py

import json
import os
import sys
from typing import List, Dict, Any

from pydantic import BaseModel, Field, ValidationError
from langchain_core.tools import tool # 导入 @tool 装饰器

# --- Path Setup ---
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

# 从项目中导入Pydantic模型
try:
    from models.simulation_schemas import SimulationInstance, ExecutionPayload
except ImportError:
    print(f"Ensure models/simulation_schemas.py exists in {PROJECT_ROOT} and contains SimulationInstance, ExecutionPayload")
    # 如果直接运行此脚本进行快速测试，可以临时在此处定义模型
    class SimulationInstance(BaseModel):
        model_id: str = Field(description="The unique identifier of the simulation model to execute.")
        inputs: Dict[str, Any] = Field(description="A dictionary of input parameters and their values for the model.")

    class ExecutionPayload(BaseModel):
        simulations: List[SimulationInstance] = Field(description="A list containing a single simulation instance to execute.")
        confirmed: bool = Field(description="Set to false for the first execution attempt to handle confirmation. Set to true if user has already confirmed.")

# --- 定义一个被 @tool 装饰的函数 ---
# 这个函数模拟我们 SimulationAgent 中的工具
@tool
def sample_tool_with_pydantic_arg(payload: ExecutionPayload) -> Dict[str, Any]:
    """
    A sample tool that expects an ExecutionPayload object.
    The 'payload' argument should be structured as:
    {
        "simulations": [{"model_id": "id", "inputs": {"key": "value"}}],
        "confirmed": false
    }
    """
    print(f"\n[sample_tool_with_pydantic_arg] Received Pydantic object: {type(payload)}")
    print(f"[sample_tool_with_pydantic_arg] Payload content: {payload.model_dump_json(indent=2)}")
    return {"status": "success", "received_payload": payload.model_dump()}

def main():
    print("--- Starting Pydantic Tool Input Test ---")

    # 1. 模拟LLM生成的 Action Input (这是一个JSON字符串)
    # 这是我们期望LLM为 sample_tool_with_pydantic_arg 生成的 Action Input
    llm_generated_action_input_str = json.dumps({
        "simulations": [
            {
                "model_id": "motor_steady_speed_estimator_v1",
                "inputs": {"Voltage_V": 100.0}
            }
        ],
        "confirmed": False
    })
    print(f"\nSimulated LLM Action Input (string): \n{llm_generated_action_input_str}")

    # --- 模拟 Langchain Tool._parse_input 和 Pydantic 校验过程 ---
    # Langchain 的 Tool 基类有一个 _parse_input 方法，它会尝试处理输入。
    # 对于带类型注解的 Pydantic 模型参数，它应该：
    #   a. 如果 Action Input 是字符串，尝试 json.loads()
    #   b. 用得到的字典去调用 Pydantic 模型的 model_validate()

    parsed_input_dict = None
    try:
        # 步骤 a: 模拟 Langchain 对 LLM 输出的 JSON 字符串的解析
        # 注意：在真实的 Langchain ReAct 流程中，Action Input 传递给 tool.run() 时
        # 通常已经是字符串了。
        print(f"\nAttempting to parse the Action Input string into a Python dictionary...")
        parsed_input_dict = json.loads(llm_generated_action_input_str)
        print(f"Successfully parsed into dictionary: \n{json.dumps(parsed_input_dict, indent=2)}")
    except json.JSONDecodeError as e:
        print(f"Error: LLM Action Input is not a valid JSON string: {e}")
        return

    # 步骤 b: 模拟 Pydantic 使用这个字典进行校验和对象实例化
    # 这是当 sample_tool_with_pydantic_arg(payload: ExecutionPayload) 被调用时，
    # Langchain/Pydantic 在幕后应该做的事情：用 parsed_input_dict 来创建 ExecutionPayload 对象。
    print(f"\nAttempting to validate the dictionary with ExecutionPayload Pydantic model...")
    try:
        # 直接使用 Pydantic 模型进行验证
        payload_object = ExecutionPayload.model_validate(parsed_input_dict)
        print(f"Successfully validated and created ExecutionPayload object: \n{payload_object.model_dump_json(indent=2)}")

        # 如果上面成功了，那么直接调用工具函数也应该成功
        print(f"\nAttempting to call the @tool decorated function with the validated Pydantic object...")
        # 注意：在实际的AgentExecutor中，Langchain会根据Action Input和函数签名来做参数绑定。
        # 如果函数只有一个Pydantic类型的参数，Langchain会尝试将解析后的字典直接传递给它。
        # 我们这里是手动模拟这个过程的最后一步。
        #
        # 在实际的 tool.run() 调用中，Langchain 会处理 Action Input -> Pydantic object 的转换。
        # Tool.run() 的大致逻辑 (非常简化):
        #   tool_input_str = llm_action_input
        #   parsed_args = tool._parse_input(tool_input_str) # 这应该返回一个字典，如 {"payload": <ExecutionPayload object>} 或直接是 <ExecutionPayload object>
        #   result = tool._run(**parsed_args) 或者 tool._run(parsed_args)

        # 我们直接调用被装饰的函数，就好像 Langchain 已经成功地为我们创建了 payload_object
        # result_from_tool_func = sample_tool_with_pydantic_arg(payload_object) # 已被Pydantic包装，不需要再次调用
        # print(f"Result from calling tool function directly: {result_from_tool_func}")


        # 更接近 Langchain Tool.run() 的模拟：
        # Langchain 的 @tool 装饰器会处理 Action Input 到函数参数的映射。
        # 如果 LLM 的 Action Input 就是我们上面定义的 llm_generated_action_input_str，
        # Langchain 在调用 sample_tool_with_pydantic_arg 时，会尝试将这个字符串
        # 解析成一个字典，然后用这个字典去匹配 'payload' 参数（因为类型是ExecutionPayload）
        print(f"\nSimulating Langchain's Tool.run() with the Action Input string...")
        # `sample_tool_with_pydantic_arg` 是一个 `Tool` 对象，因为它被 @tool 装饰了
        # `Tool.run()` 通常期望一个单一的字符串或字典。
        # 当参数是Pydantic模型时，它期望一个能被解析成该模型实例的输入。
        try:
            # Langchain Tool.run() 通常接受一个位置参数或一个字典。
            # 对于单个Pydantic模型参数，它应该能处理直接的字典或能解析成该字典的JSON字符串。
            tool_run_result = sample_tool_with_pydantic_arg.run(llm_generated_action_input_str)
            # 或者如果 run 期望一个字典:
            # tool_run_result = sample_tool_with_pydantic_arg.run({"payload": llm_generated_action_input_str}) # 这取决于具体Langchain版本和Tool实现
            # 或者更可能是:
            # tool_run_result = sample_tool_with_pydantic_arg.run(json.loads(llm_generated_action_input_str))


            print(f"Result from sample_tool_with_pydantic_arg.run(): \n{json.dumps(tool_run_result, indent=2)}")
            print("If this succeeded without Pydantic errors, Langchain's tool argument parsing for Pydantic models is working correctly with the provided JSON string.")

        except ValidationError as ve:
            print(f"ValidationError during sample_tool_with_pydantic_arg.run(): \n{ve.errors(include_input=False)}") # exclude input for cleaner log
        except Exception as e_run:
            print(f"Error during sample_tool_with_pydantic_arg.run(): {type(e_run).__name__} - {e_run}")


    except ValidationError as ve:
        print(f"Error: Pydantic validation failed when validating the dictionary.")
        print(f"Validation Errors: \n{json.dumps(ve.errors(), indent=2)}") # Pydantic v2 uses .errors()
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

    print("\n--- Pydantic Tool Input Test Finished ---")

if __name__ == "__main__":
    main()