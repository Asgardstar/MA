import matlab.engine
import sys
import os
from mcp.server.fastmcp import FastMCP
from pathlib import Path
from typing import Dict
import io

# --- 1. Global MATLAB Engine Management ---
# The engine is started once when the server launches and is kept running.
print("Starting MATLAB engine... This may take a moment.")
_matlab_engine_instance = None
try:
    _matlab_engine_instance = matlab.engine.start_matlab()
    print("MATLAB engine started successfully.")
except Exception as e:
    print(f"Fatal Error: Could not start MATLAB engine. {e}", file=sys.stderr)
    sys.exit(1)

def get_matlab_engine():
    """Returns the globally managed MATLAB engine instance."""
    if _matlab_engine_instance is None:
        raise RuntimeError("The global MATLAB engine is not running.")
    return _matlab_engine_instance

# --- 2. MCP Server and Script Directory Setup ---
mcp = FastMCP(
    "MATLABCodeAssistant",
    port=8003  # Using a new port to avoid conflicts.
)

MATLAB_SCRIPTS_DIR = Path("matlab_scripts")
MATLAB_SCRIPTS_DIR.mkdir(exist_ok=True)
# Add the script directory to MATLAB's path at startup.
eng = get_matlab_engine()
eng.addpath(str(MATLAB_SCRIPTS_DIR.resolve()), nargout=0)
print(f"MATLAB script directory '{MATLAB_SCRIPTS_DIR.resolve()}' has been added to the MATLAB path.")


# --- 3. Define MCP Tools ---

@mcp.tool()
def create_matlab_script(script_name: str, code: str) -> Dict[str, str]:
    """
    Creates and saves a MATLAB .m script file to the local filesystem.
    This tool is responsible for file I/O, not code generation.

    Args:
        script_name: The name for the script (without the .m extension).
        code: The complete string content of the MATLAB script.

    Returns:
        A dictionary with the operation status and a confirmation message.
    """
    try:
        if not script_name.isidentifier():
            raise ValueError(f"The script name '{script_name}' is invalid. Use letters, numbers, underscores, and do not start with a number.")

        script_path = MATLAB_SCRIPTS_DIR / f"{script_name}.m"
        
        with open(script_path, 'w', encoding='utf-8') as f:
            f.write(code)
        
        message = f"Script '{script_name}.m' was successfully created at: {script_path.resolve()}"
        print(message)
        return {"status": "success", "message": message}
    except Exception as e:
        error_message = f"Failed to create script '{script_name}.m': {str(e)}"
        print(error_message, file=sys.stderr)
        return {"status": "error", "message": error_message}

@mcp.tool()
def execute_matlab_script(script_name: str) -> Dict[str, str]:
    """
    Executes a previously created .m script using the persistent MATLAB engine
    and captures any command-line output.

    Args:
        script_name: The name of the script to execute (without .m extension).

    Returns:
        A dictionary containing the execution status and the captured output.
    """
    try:
        eng = get_matlab_engine()
        
        script_file = MATLAB_SCRIPTS_DIR / f"{script_name}.m"
        if not script_file.exists():
            raise FileNotFoundError(f"The script '{script_name}.m' does not exist.")

        output_buffer = io.StringIO()
        
        print(f"Executing '{script_name}.m' in MATLAB...")
        # nargout=0 is crucial as scripts do not return values.
        eng.eval(script_name, nargout=0, stdout=output_buffer, stderr=output_buffer)
        
        captured_output = output_buffer.getvalue().strip()
        print("Execution finished.")
        
        return {
            "status": "success",
            "output": captured_output
        }
    except Exception as e:
        error_message = f"An error occurred while executing '{script_name}.m': {str(e)}"
        print(error_message, file=sys.stderr)
        return {
            "status": "error",
            "output": error_message
        }

# --- 4. Run the Server ---
if __name__ == "__main__":
    try:
        print("Starting MCP server for MATLAB on port 8003...")
        mcp.run(transport="streamable-http")
    finally:
        # This part will run when you stop the server (e.g., with Ctrl+C).
        print("\nServer is shutting down. Stopping MATLAB engine...")
        if _matlab_engine_instance:
            _matlab_engine_instance.quit()
        print("MATLAB engine stopped.")