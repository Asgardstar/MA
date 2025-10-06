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
    """Query all the current parameters"""
    parameters = mod.getParameters()
    return parameters

@mcp.tool()
def query_specific_parameters(specific_parameter:str):
    """
    Query one of the current parameters
    the parameters must be one of the eight parameters:
    A (Surface Area),
    P_electric (Electric Power Output from battery),
    R_ref (Reference Resistance),
    T_ambient_C (Ambient Temperature in Celsius),
    T_ref (Reference Temperature),
    V_ocv (Open Circuit Voltage),
    alpha (Temperature Coefficient of Resistance),
    h (Heat Transfer Coefficient)
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
    Set the model parameters.

    Args:
    T_C_value (Ambient Temperature in Celsius),
    V_ocv_value (Open Circuit Voltage),
    h_value (Heat Transfer Coefficient),
    A_value (Surface Area),
    R_ref_value (Reference Resistance),
    alpha_value (Temperature Coefficient of Resistance),
    T_ref_K_value (Reference Temperature), 

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

'''
@mcp.tool()
def set_ambient_temperature(T_C_value: float):
    """Sets the ambient temperature in Celsius for the EV cell."""
    mod.setParameters(f"T_ambient_C={T_C_value}")

@mcp.tool()
def set_open_circuit_voltage(V_ocv_value: float):
    """Sets the open-circuit voltage (OCV) of the cell."""
    mod.setParameters(f"V_ocv={V_ocv_value}")

@mcp.tool()
def set_heat_transfer_coefficient(h_value: float):
    """Sets the equivalent heat transfer coefficient (cooling system effectiveness)."""
    mod.setParameters(f"h={h_value}")

@mcp.tool()
def set_surface_area(A_value: float):
    """Sets the heat dissipation surface area of the cell."""
    mod.setParameters(f"A={A_value}")

@mcp.tool()
def set_reference_resistance(R_ref_value: float):
    """Sets the reference internal resistance at the reference temperature."""
    mod.setParameters(f"R_ref={R_ref_value}")

@mcp.tool()
def set_resistance_temp_coeff(alpha_value: float):
    """Sets the temperature coefficient of resistance."""
    mod.setParameters(f"alpha={alpha_value}")

@mcp.tool()
def set_reference_temperature(T_ref_K_value: float):
    """Sets the reference temperature of battery resistance in Kelvin."""
    mod.setParameters(f"T_ref={T_ref_K_value}")
'''
#run the simulation and give results
@mcp.tool()
def simulate_battery_steady_state(power_output: float) -> dict[str, float]:
    """
    Runs a steady-state thermal simulation for the EV battery model.

    This tool sets a new power output value, runs the simulation, and returns
    the final steady-state results for temperature and internal resistance.

    :param power_output: The desired continuous power output in Watts (W).
    :return: A dictionary containing the final temperature in Celsius and the internal resistance in Ohms.
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