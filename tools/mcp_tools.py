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
    server, and returns the final response.
    """
    final_response = "No response from AI."
    messages: List[Any] = []

    # Define the fixed list of three MCP server URLs.
    mcp_server_urls = [
        "http://localhost:8001/mcp",
        "http://localhost:8002/mcp",
        "http://localhost:8003/mcp" 
    ]
    all_langchain_tools = []
    tool_to_session_map: Dict[str, ClientSession] = {}

    try:
        llm = get_llm("mcpagent")

        # Extend the 'async with' block to handle three connections.
        async with streamablehttp_client(mcp_server_urls[0]) as streams1, \
                     streamablehttp_client(mcp_server_urls[1]) as streams2, \
                     streamablehttp_client(mcp_server_urls[2]) as streams3:
            
            async with ClientSession(streams1[0], streams1[1]) as session1, \
                       ClientSession(streams2[0], streams2[1]) as session2, \
                       ClientSession(streams3[0], streams3[1]) as session3:

                sessions = [session1, session2, session3]
                for session in sessions:
                    await session.initialize()
                    tool_info = await session.list_tools()
                    
                    for tool in tool_info.tools:
                        all_langchain_tools.append({
                            "type": "function",
                            "function": {
                                "name": tool.name,
                                "description": tool.description,
                                "parameters": tool.inputSchema,
                            },
                        })
                        tool_to_session_map[tool.name] = session

                llm_with_tools = llm.bind_tools(all_langchain_tools)

                messages.append(HumanMessage(content=query))
                ai_response = await llm_with_tools.ainvoke(messages)
                messages.append(ai_response)

                if ai_response.tool_calls:
                    for tool_call in ai_response.tool_calls:
                        tool_name = tool_call['name']
                        tool_args = tool_call['args']
                        
                        session_to_use = tool_to_session_map.get(tool_name)
                        
                        if session_to_use:
                            tool_result = await session_to_use.call_tool(tool_name, tool_args)
                            
                            # Improved handling for the tool output
                            if tool_result.content:
                                if isinstance(tool_result.content[0], dict):
                                    tool_output = json.dumps(tool_result.content[0])
                                else:
                                    tool_output = " ".join(str(item) for item in tool_result.content)
                            else:
                                tool_output = "Tool executed but returned no content."
                        else:
                            tool_output = f"Error: Tool '{tool_name}' not found on any connected server."

                        messages.append(
                            ToolMessage(
                                content=tool_output,
                                tool_call_id=tool_call['id']
                            )
                        )

                    final_response_message = await llm.ainvoke(messages)
                    final_response = final_response_message.content
                    messages.append(final_response_message)
                else:
                    final_response = ai_response.content

    except Exception as e:
        import traceback
        error_details = traceback.format_exc()
        final_response = f"An error occurred during MCP client execution: {e}\n\nFull Traceback:\n{error_details}"

    return final_response


def mcp_chat_tool(query: str) -> str:
    """
    A synchronous wrapper for the asynchronous run_mcp_client function.
    """
    try:
        return asyncio.run(run_mcp_client(query))
    except Exception as e:
        return f"Failed to run MCP client: {e}"