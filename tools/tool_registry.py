# tools/tool_registry.py
import asyncio
import json
from typing import List, Dict, Callable, Coroutine, Any
from langchain.tools import Tool
from mcp import ClientSession
from mcp.client.streamable_http import streamablehttp_client
import nest_asyncio

# Apply the patch for nested asyncio loops
nest_asyncio.apply()

# --- Tool Creation Logic ---

def _create_tool_func(session: ClientSession, tool_name: str) -> Callable[..., str]:
    """
    Factory function to create a synchronous callable function for a given async MCP tool.
    """
    async def tool_func(**kwargs) -> str:
        try:
            result = await session.call_tool(tool_name, kwargs)
            if result.content:
                if isinstance(result.content[0], dict):
                    return json.dumps(result.content[0])
                return " ".join(str(item) for item in result.content)
            return "Tool executed successfully with no return content."
        except Exception as e:
            return f"Error calling tool '{tool_name}': {e}"

    def sync_wrapper(**kwargs) -> str:
        """Synchronous wrapper to run the async tool function in an event loop."""
        try:
            loop = asyncio.get_event_loop()
            if loop.is_running():
                # If a loop is already running, create a task and run it
                return asyncio.ensure_future(tool_func(**kwargs))
            else:
                # If no loop is running, use run_until_complete
                return loop.run_until_complete(tool_func(**kwargs))
        except RuntimeError:
             # Fallback for environments where get_event_loop fails
             return asyncio.run(tool_func(**kwargs))
             
    return sync_wrapper

async def _discover_tools_async(server_urls: List[str]) -> List[Tool]:
    """
    Asynchronously discovers and creates LangChain Tools from a list of MCP server URLs.
    """
    discovered_tools: List[Tool] = []
    
    # Dynamically create a context manager for all server connections
    async with streamablehttp_client(server_urls[0]) as s1, \
                 streamablehttp_client(server_urls[1]) if len(server_urls) > 1 else asyncio.Task(asyncio.sleep(0)) as s2, \
                 streamablehttp_client(server_urls[2]) if len(server_urls) > 2 else asyncio.Task(asyncio.sleep(0)) as s3:
        
        streams = [s for s in [s1, s2, s3] if isinstance(s, tuple)]
        
        async with ClientSession(streams[0][0], streams[0][1]) as session1, \
                     ClientSession(streams[1][0], streams[1][1]) if len(streams) > 1 else asyncio.Task(asyncio.sleep(0)) as session2, \
                     ClientSession(streams[2][0], streams[2][1]) if len(streams) > 2 else asyncio.Task(asyncio.sleep(0)) as session3:

            sessions = [s for s in [session1, session2, session3] if isinstance(s, ClientSession)]
            
            await asyncio.gather(*(session.initialize() for session in sessions))

            for session in sessions:
                tool_info = await session.list_tools()
                for tool_metadata in tool_info.tools:
                    new_tool = Tool.from_function(
                        func=_create_tool_func(session, tool_metadata.name),
                        name=tool_metadata.name,
                        description=tool_metadata.description,
                        args_schema=tool_metadata.inputSchema,
                    )
                    discovered_tools.append(new_tool)
    
    print(f"Discovered {len(discovered_tools)} tools from {server_urls}: {[t.name for t in discovered_tools]}")
    return discovered_tools

def get_mcp_tools(server_urls: List[str]) -> List[Tool]:
    """
    Synchronously discovers and returns a list of MCP tools from the given server URLs.
    """
    try:
        loop = asyncio.get_event_loop()
        if loop.is_running():
             # This is a bit of a trick for running async code from sync in a running loop
             # It's not ideal but works for this specific langchain/streamlit context
             task = loop.create_task(_discover_tools_async(server_urls))
             # In a real async application, you'd await this. Here we have to block.
             # This is a simplified approach. A more robust solution might use a thread.
             return loop.run_until_complete(asyncio.gather(task))[0]
        else:
            return loop.run_until_complete(_discover_tools_async(server_urls))
    except RuntimeError:
        return asyncio.run(_discover_tools_async(server_urls))

# --- Pre-configured Tool Sets for different Agents ---

def get_simulation_agent_tools() -> List[Tool]:
    """
    Gets the tools specifically for the SimulationAgent (pre-defined models).
    """
    # Ports 8001 (Battery) and 8002 (Motor Speed)
    simulation_server_urls = [
        "http://localhost:8001/mcp",
        "http://localhost:8002/mcp"
    ]
    return get_mcp_tools(simulation_server_urls)

def get_mcp_agent_tools() -> List[Tool]:
    """
    Gets the tools specifically for the MCPAgent (MATLAB script execution).
    """
    # Port 8003 (General MATLAB Server)
    mcp_server_urls = ["http://localhost:8003/mcp"]
    return get_mcp_tools(mcp_server_urls)