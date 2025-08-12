from mcp.server.fastmcp import FastMCP
from OMPython import ModelicaSystem
import numpy as np

# Create an MCP server
mcp = FastMCP("Demo")

model_path = "K:/MasterThesis/OM_models/MassSpringDamper.mo"
model_name = "MassSpringDamper"
    
mod = ModelicaSystem(model_path, model_name)
    
mod.buildModel()
mod.simulate()

# Add an addition tool
@mcp.tool()
def getDamperResult(t: float) -> dict[str, float]:
    """Get the result of the damper at time t"""
    solutions = mod.getSolutions(["time", "x", "v"])
    time_values = solutions[0]
    x_values = solutions[1]
    v_values = solutions[2]

    x_at_t = np.interp(t, time_values, x_values)
    v_at_t = np.interp(t, time_values, v_values)    
    return {"x": x_at_t, "v": v_at_t}

@mcp.tool()
def setMass(m: float) -> dict[str, float]:
    """Set the mass of the damper"""
    mod.setParameters({"m": m})
    return {"mass": m}

if __name__ == "__main__":
    mcp.run(transport="sse")