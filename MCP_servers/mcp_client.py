import asyncio
import os
import json
from typing import List, Dict
from dotenv import load_dotenv
load_dotenv()

# Make sure to install the necessary libraries:
# pip install mcp-client openai
from mcp import ClientSession
from mcp.client.streamable_http import streamablehttp_client
from openai import AsyncOpenAI

API_KEY = os.environ.get("GOOGLE_API_KEY")
BASE_URL = "https://generativelanguage.googleapis.com/v1beta/openai/"

async def main():
    """
    Main function to run the MCP chat client.
    """
    if not API_KEY:
        print("Error: GOOGLE_API_KEY environment variable not set.")
        return

    llm = AsyncOpenAI(api_key=API_KEY, base_url=BASE_URL)

    # Connect to the MCP server using a clean 'async with' block
    async with streamablehttp_client("http://localhost:8002/mcp") as (
        read_stream,
        write_stream,
        _,
    ):
        # Create a client session
        async with ClientSession(read_stream, write_stream) as session:
            # Initialize the MCP connection
            await session.initialize()

            # Get the list of available tools from the server
            tool_info = await session.list_tools()
            available_tools = [
                {
                    "type": "function",
                    "function": {
                        "name": tool.name,
                        "description": tool.description,
                        "parameters": tool.inputSchema,
                    },
                }
                for tool in tool_info.tools
            ]
            print(f"Available tools: {[tool.name for tool in tool_info.tools]}")
        
            print("\nStarting chat loop...")
            print("Enter 'quit' or 'exit' to exit.")

            # Maintain conversation history
            # messages list is defined here to preserve context across turns
            messages: List[Dict[str, any]] = []

            while True:
                try:
                    query = input("\nYou: ").strip()
                    if query.lower() in ["quit", "exit"]:
                        break

                    # Step 1: Add user's message to the history
                    messages.append({"role": "user", "content": query})

                    # Step 2: Call the LLM with the current conversation history and available tools
                    print("AI is thinking...")
                    response = await llm.chat.completions.create(
                        model="gemini-2.0-flash",  # Use a model that supports tool calling
                        messages=messages,
                        tools=available_tools,
                        tool_choice="auto",  # Let the model decide when to call tools
                    )
                    response_message = response.choices[0].message
                    
                    # Step 3: Add the assistant's response to the history.
                    # This is crucial, whether it's a text reply or a tool call request.
                    messages.append(response_message)

                    # Step 4: Check if the model decided to call a tool
                    if response_message.tool_calls:
                        print("Executing tool...")
                        # Step 5a: Execute the tool call(s)
                        for tool_call in response_message.tool_calls:
                            tool_name = tool_call.function.name
                            # The arguments are a JSON string, so we need to parse them
                            tool_args = json.loads(tool_call.function.arguments)
                            
                            print(f"Calling tool '{tool_name}' with arguments: {tool_args}")
                            
                            # Call the tool via the MCP session
                            tool_result = await session.call_tool(tool_name, tool_args)
                            
                            # **CRITICAL FIX**: The tool result's content might not be a plain string.
                            # We serialize it to a JSON string to ensure the API can handle it.
                            tool_output = " ".join(str(item) for item in tool_result.content)

                            # Step 5b: Add the tool's result to the conversation history
                            messages.append(
                                {
                                    "tool_call_id": tool_call.id,
                                    "role": "tool",
                                    "name": tool_name,
                                    "content": tool_output,
                                }
                            )

                        # Step 6: Call the LLM again with the tool result included
                        # The model will now generate a natural language response based on the tool's output.
                        print("AI is summarizing the result...")
                        second_response = await llm.chat.completions.create(
                            model="gemini-2.0-flash",
                            messages=messages,
                        )
                        final_response = second_response.choices[0].message.content
                        
                        # Add the final response to history
                        messages.append(second_response.choices[0].message)

                    else:
                        # If no tool was called, the first response is the final one
                        final_response = response_message.content

                    # Step 7: Print the final response to the user
                    print(f"\nAI: {final_response}")

                except (KeyboardInterrupt, EOFError):
                    # Allow clean exit with Ctrl+C or Ctrl+D
                    break
                except Exception as e:
                    print(f"\nAn error occurred: {e}")
                    # Optional: clear messages history on error to start fresh


    
    print("\nChat session ended.")


if __name__ == "__main__":
    asyncio.run(main())