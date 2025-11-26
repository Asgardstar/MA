from mcp.server.fastmcp import FastMCP
from OMPython import ModelicaSystem
import numpy as np
import os
from dotenv import load_dotenv

load_dotenv()

# Create an MCP server
mcp = FastMCP("BatteryThermalModel",port=8001)

# Define model path and name
model_path = os.environ.get("BATTERY_THERMAL_MODEL_PATH")
if not model_path:
    raise ValueError("Error: BATTERY_THERMAL_MODEL_PATH not found in the .env file.")

model_name = os.environ.get("BATTERY_THERMAL_MODEL_NAME")
if not model_name:
    raise ValueError("Error: BATTERY_THERMAL_MODEL_NAME not found in the .env file.")

mod = ModelicaSystem(model_path, model_name)

#query the parameters
@mcp.tool()
def query_parameters():
    """
    Queries and returns all current input parameters and their values for the Battery Thermal Model.
    """
    parameters = mod.getParameters()
    return parameters

@mcp.tool()
def query_specific_parameters(specific_parameter:str):
    """
    Queries and returns the value of a single specified parameter from the Battery Thermal Model.
    Valid parameters are: A, P_electric, R_ref, T_ambient_C, T_ref, V_ocv, alpha, h.
    """
    parameter_value = mod.getParameters(specific_parameter)
    return parameter_value

#define the parameters

@mcp.tool()
def set_parameters(
        T_C_value: float = None,
        V_ocv_value: float = None,
        h_value: float = None,
        A_value: float = None,
        R_ref_value: float = None,
        alpha_value: float = None,
        T_ref_K_value: float = None,

):
    """
    Sets one or more input parameters for a future simulation of the Battery Thermal Model.
    
    Args:
        T_C_value (float): Ambient Temperature in Celsius.
        V_ocv_value (float): Open Circuit Voltage in Volts.
        h_value (float): Heat Transfer Coefficient.
        A_value (float): Surface Area.
        R_ref_value (float): Reference Resistance in Ohms.
        alpha_value (float): Temperature Coefficient of Resistance.
        T_ref_K_value (float): Reference Temperature in Kelvin.
    """
    if T_C_value is not None:
        mod.setParameters(f"T_ambient_C={T_C_value}")
    if V_ocv_value is not None:
        mod.setParameters(f"V_ocv={V_ocv_value}")
    if h_value is not None:
        mod.setParameters(f"h={h_value}")
    if A_value is not None:
        mod.setParameters(f"A={A_value}")
    if R_ref_value is not None:
        mod.setParameters(f"R_ref={R_ref_value}")
    if alpha_value is not None:
        mod.setParameters(f"alpha={alpha_value}")
    if T_ref_K_value is not None:
        mod.setParameters(f"T_ref={T_ref_K_value}")

#run the simulation and give results
@mcp.tool()
def simulate_battery_steady_state(power_output: float) -> dict[str, float]:
    """
    Calculates the steady-state temperature and/or the internal resistance of the battery by running a thermal simulation.
    Use this tool when asked to find, calculate, or determine the battery's temperature for a given power output.

    Args:
        power_output (float): The continuous electric power output in Watts (W) to be used for the simulation.
    
    Returns:
        A dictionary containing the final steady-state temperature in Celsius and the internal resistance in Ohms.
    """
    mod.setParameters(f"P_electric={power_output}")
    
    mod.simulate()
    
    temperature = mod.getSolutions("T_batt_C")[0][-1]
    resistance = mod.getSolutions("R_internal")[0][-1]

    return {
        "temperature_celsius": temperature,
        "resistance_ohm": resistance
    }


if __name__ == "__main__":
    mcp.run(transport="streamable-http")