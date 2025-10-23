# tools/mcp_tools.py
import asyncio
import os
import json
from typing import List, Dict, Any
from dotenv import load_dotenv

from mcp import ClientSession
from mcp.client.streamable_http import streamablehttp_client

# LangChain and model imports
from models.llm import get_llm
from langchain_core.messages import HumanMessage, AIMessage, ToolMessage

# Ensure .env variables are loaded
load_dotenv()

async def run_mcp_client(query: str) -> str:
    """
    Connects to three specific MCP servers, combines their tools,
    uses a LangChain LLM to decide on a tool call, executes it on the correct
    server, extracts meaningful output, summarizes it, and returns the final response.
    """
    final_response = "No response from AI."
    messages: List[Any] = []

    # Define the fixed list of three MCP server URLs.
    mcp_server_urls = [
        "http://localhost:8001/mcp", # Battery
        "http://localhost:8002/mcp", # Motor
        "http://localhost:8003/mcp"  # MATLAB
    ]
    all_langchain_tools = []
    tool_to_session_map: Dict[str, ClientSession] = {}

    try:
        llm = get_llm("mcpagent") # LLM for tool selection and final summary

        # Extend the 'async with' block to handle three connections.
        async with streamablehttp_client(mcp_server_urls[0]) as streams1, \
                     streamablehttp_client(mcp_server_urls[1]) as streams2, \
                     streamablehttp_client(mcp_server_urls[2]) as streams3:
            
            async with ClientSession(streams1[0], streams1[1]) as session1, \
                       ClientSession(streams2[0], streams2[1]) as session2, \
                       ClientSession(streams3[0], streams3[1]) as session3:

                sessions = [session1, session2, session3]
                for idx, session in enumerate(sessions):
                    await session.initialize()
                    tool_info = await session.list_tools()
                    
                    for tool in tool_info.tools:
                        # Add tool to the list for the LLM
                        all_langchain_tools.append({
                            "type": "function",
                            "function": {
                                "name": tool.name,
                                "description": tool.description,
                                "parameters": tool.inputSchema,
                            },
                        })
                        # Map tool name back to the correct session
                        tool_to_session_map[tool.name] = session
                        print(f"Registered tool '{tool.name}' from server {mcp_server_urls[idx]}")


                if not all_langchain_tools:
                    return "Error: Could not connect to any MCP server or no tools found."
                    
                llm_with_tools = llm.bind_tools(all_langchain_tools)

                messages.append(HumanMessage(content=query))
                ai_response = await llm_with_tools.ainvoke(messages)
                messages.append(ai_response)

                if ai_response.tool_calls:
                    for tool_call in ai_response.tool_calls:
                        tool_name = tool_call['name']
                        tool_args = tool_call['args']
                        
                        session_to_use = tool_to_session_map.get(tool_name)
                        
                        tool_output_content = f"Error: Tool '{tool_name}' not found on any connected server." # Default error

                        if session_to_use:
                            try:
                                print(f"Calling tool '{tool_name}' with args: {tool_args} on session {session_to_use}")
                                tool_result = await session_to_use.call_tool(tool_name, tool_args)
                                print(f"Raw result from tool '{tool_name}': {tool_result}")

                                # --- START: Optimized Result Handling ---
                                tool_output_content = "Tool executed but returned no specific output content." # Default success message

                                if tool_result.content:
                                    first_content_item = tool_result.content[0]
                                    
                                    if isinstance(first_content_item, dict):
                                        result_dict = first_content_item
                                        # Prioritize the 'output' key for direct results (like from MATLAB script)
                                        if result_dict.get("output") is not None: # Check explicitly for None
                                            tool_output_content = str(result_dict["output"])
                                        # Handle simulation results (e.g., battery temp)
                                        elif "temperature_celsius" in result_dict or "resistance_ohm" in result_dict:
                                             # Format simulation results clearly
                                             parts = []
                                             if "temperature_celsius" in result_dict:
                                                 parts.append(f"Temperature: {result_dict['temperature_celsius']:.2f} °C")
                                             if "resistance_ohm" in result_dict:
                                                 parts.append(f"Resistance: {result_dict['resistance_ohm']:.4f} Ω")
                                             tool_output_content = ", ".join(parts) if parts else str(result_dict)
                                        # Handle motor power calculation results
                                        elif "electric_power_watts" in result_dict:
                                            tool_output_content = f"Calculated Electric Power: {result_dict['electric_power_watts']:.2f} W"
                                        # Handle parameter query results (could be dict or single value)
                                        elif tool_name.startswith("query_"):
                                             tool_output_content = f"Current parameters: {json.dumps(result_dict)}"
                                        # Handle parameter setting confirmation
                                        elif tool_name.startswith("set_") and result_dict.get("status") == "success":
                                            tool_output_content = result_dict.get("message", "Parameters set successfully.")
                                        # Handle errors reported by the tool itself
                                        elif result_dict.get("status") == "error":
                                            tool_output_content = f"Tool Error: {result_dict.get('message', 'Unknown error from tool')}"
                                        # Fallback for unexpected dictionaries
                                        else:
                                            try:
                                                tool_output_content = json.dumps(result_dict)
                                            except TypeError:
                                                tool_output_content = str(result_dict)
                                    else:
                                        # If content is not a dict, join as string
                                        tool_output_content = " ".join(str(item) for item in tool_result.content)
                                # --- END: Optimized Result Handling ---

                            except Exception as tool_exec_err:
                                import traceback
                                error_details = traceback.format_exc()
                                tool_output_content = f"Error during execution of tool '{tool_name}': {tool_exec_err}\nTraceback:\n{error_details}"
                                print(f"Error executing tool: {tool_output_content}")


                        # Append the processed content to messages for the LLM summarizer
                        messages.append(
                            ToolMessage(
                                content=tool_output_content,
                                tool_call_id=tool_call['id']
                            )
                        )
                        print(f"Content sent back to LLM for summarization: '{tool_output_content}'")


                    # Call LLM again to get the final natural language response based on tool results
                    final_response_message = await llm.ainvoke(messages)
                    final_response = final_response_message.content
                    messages.append(final_response_message)
                else:
                    # If the LLM decided not to call a tool initially
                    final_response = ai_response.content

    except Exception as e:
        import traceback
        error_details = traceback.format_exc()
        final_response = f"An error occurred during MCP client execution: {e}\n\nFull Traceback:\n{error_details}"
        print(f"Overall MCP Client Error: {final_response}")

    print(f"Final response being returned: '{final_response}'")
    return final_response


def mcp_chat_tool(query: str) -> str:
    """
    A synchronous wrapper for the asynchronous run_mcp_client function.
    """
    try:
        # Use asyncio.run() only if there's no existing event loop
        # This handles environments like Streamlit that might have their own loop
        try:
            loop = asyncio.get_running_loop()
        except RuntimeError: # 'RuntimeError: There is no current event loop...'
            loop = None

        if loop and loop.is_running():

             return asyncio.run(run_mcp_client(query))
        else:
             return asyncio.run(run_mcp_client(query))
             
    except Exception as e:
        print(f"Error in synchronous wrapper mcp_chat_tool: {e}")
        return f"Failed to run MCP client: {e}"