# mcp_server.py (Stateful Version)

import matlab.engine
import sys
from mcp.server.fastmcp import FastMCP
from typing import Union, Dict, Any

# --- Step 1: Start MATLAB Engine ---
# This part remains the same.
print("Starting MATLAB engine... This may take a moment.")
try:
    eng = matlab.engine.start_matlab()
    matlab_script_path = r'D:\OneDrive - Students RWTH Aachen University\MATLAB Models'
    eng.addpath(matlab_script_path, nargout=0)
    print("MATLAB engine started successfully.")
except Exception as e:
    print(f"Fatal: Could not start MATLAB engine. {e}", file=sys.stderr)
    sys.exit(1)

# --- Step 2: Define the Stateful Wrapper Class ---
class MatlabModelManager:
    """
    A class to manage the state of the MATLAB model parameters.
    It holds the parameters in a dictionary and provides methods
    to interact with them.
    """
    def __init__(self, matlab_engine):
        self.eng = matlab_engine
        # Store all model parameters with default values.
        self.parameters = {
            'vehicle_speed_kph': 1,
            'road_grade_percent': 1,
            'vehicle_mass_kg': 1,
            'drag_coeff': 1,
            'frontal_area_m2': 1,
            'rolling_res_coeff': 1,
            'powertrain_eff':1,
            'g': 9.81,
            'rho': 1.225
        }
        print("MatlabModelManager initialized with default parameters.")

    def get_all_parameters(self) -> Dict[str, float]:
        """Returns a copy of the current parameters."""
        return self.parameters.copy()

    def set_parameter(self, name: str, value: float) -> Dict[str, Any]:
        """Sets a specific parameter's value."""
        if name in self.parameters:
            self.parameters[name] = value
            return {"status": "success", "message": f"Parameter '{name}' set to {value}"}
        else:
            return {"status": "error", "message": f"Parameter '{name}' is not valid."}

    def run_calculation(self) -> Dict[str, Any]:
        """Runs the MATLAB calculation with the current stored parameters."""
        try:
            # Unpack the parameters from the dictionary in the correct order.
            power_output = self.eng.calculate_electric_power(
                self.parameters['vehicle_speed_kph'],
                self.parameters['road_grade_percent'],
                self.parameters['vehicle_mass_kg'],
                self.parameters['drag_coeff'],
                self.parameters['frontal_area_m2'],
                self.parameters['rolling_res_coeff'],
                self.parameters['powertrain_eff'],
                self.parameters['g'],
                self.parameters['rho'],
                nargout=1
            )
            return {"status": "success", "electric_power_watts": power_output}
        except Exception as e:
            return {"status": "error", "message": str(e)}

# --- Step 3: Create Server and Model Manager Instance ---
mcp = FastMCP(
    " Vehicle Power Calculator",
    port=8002
)
# Create a single instance of our manager.
model_manager = MatlabModelManager(eng)


# --- Step 4: Create MCP Tools that Use the Manager ---

@mcp.tool()
def get_all_parameters() -> Dict[str, float]:
    """Query all current model parameters and their values."""
    return model_manager.get_all_parameters()

from typing import Any, Dict, List, Optional

@mcp.tool()
def set_vehicle_parameters(
    speed_kph: Optional[float] = None,
    grade_percent: Optional[float] = None,
    mass_kg: Optional[float] = None,
    drag_coefficient: Optional[float] = None,
    frontal_area_m2: Optional[float] = None,
    rolling_resistance_coeff: Optional[float] = None,
    powertrain_efficiency: Optional[float] = None,
    gravity_ms2: Optional[float] = None,
    air_density_kgm3: Optional[float] = None,
) -> List[Dict[str, Any]]:
    """
    Sets one or more vehicle model parameters in a single call.

    Args:
        speed_kph: Vehicle speed in kilometers per hour (km/h).
        grade_percent: Road grade in percent (%).
        mass_kg: Vehicle mass in kilograms (kg).
        drag_coefficient: Aerodynamic drag coefficient (unitless).
        frontal_area_m2: Vehicle's frontal area in square meters (m^2).
        rolling_resistance_coeff: Rolling resistance coefficient (unitless).
        powertrain_efficiency: Powertrain efficiency (e.g., 0.9 for 90%).
        gravity_ms2: Acceleration due to gravity in m/s^2.
        air_density_kgm3: Air density in kilograms per cubic meter (kg/m^3).

    Returns:
        A list of dictionaries, each confirming a parameter change.
    """
    
    results = []

    if speed_kph is not None:
        results.append(model_manager.set_parameter('vehicle_speed_kph', speed_kph))
    
    if grade_percent is not None:
        results.append(model_manager.set_parameter('road_grade_percent', grade_percent))

    if mass_kg is not None:
        results.append(model_manager.set_parameter('vehicle_mass_kg', mass_kg))

    if drag_coefficient is not None:
        results.append(model_manager.set_parameter('drag_coeff', drag_coefficient))

    if frontal_area_m2 is not None:
        results.append(model_manager.set_parameter('frontal_area_m2', frontal_area_m2))

    if rolling_resistance_coeff is not None:
        results.append(model_manager.set_parameter('rolling_res_coeff', rolling_resistance_coeff))

    if powertrain_efficiency is not None:
        results.append(model_manager.set_parameter('powertrain_eff', powertrain_efficiency))

    if gravity_ms2 is not None:
        results.append(model_manager.set_parameter('g', gravity_ms2))

    if air_density_kgm3 is not None:
        results.append(model_manager.set_parameter('rho', air_density_kgm3))

    return results

'''
@mcp.tool()
def set_vehicle_speed(speed_kph: float) -> Dict[str, Any]:
    """Sets the vehicle speed in km/h."""
    return model_manager.set_parameter('vehicle_speed_kph', speed_kph)

@mcp.tool()
def set_road_grade(grade_percent: float) -> Dict[str, Any]:
    """Sets the road grade in percent."""
    return model_manager.set_parameter('road_grade_percent', grade_percent)

@mcp.tool()
def set_vehicle_mass(mass_kg: float) -> Dict[str, Any]:
    """Sets the vehicle mass in kg."""
    return model_manager.set_parameter('vehicle_mass_kg', mass_kg)

@mcp.tool()
def set_drag_coefficient(coeff: float) -> Dict[str, Any]:
    """Sets the aerodynamic drag coefficient."""
    return model_manager.set_parameter('drag_coeff', coeff)

@mcp.tool()
def set_frontal_area(area_m2: float) -> Dict[str, Any]:
    """Sets the vehicle's frontal area in square meters (m^2)."""
    return model_manager.set_parameter('frontal_area_m2', area_m2)

@mcp.tool()
def set_rolling_resistance_coeff(coeff: float) -> Dict[str, Any]:
    """Sets the rolling resistance coefficient."""
    return model_manager.set_parameter('rolling_res_coeff', coeff)

@mcp.tool()
def set_powertrain_efficiency(efficiency: float) -> Dict[str, Any]:
    """Sets the powertrain efficiency (e.g., 0.9 for 90%)."""
    return model_manager.set_parameter('powertrain_eff', efficiency)

@mcp.tool()
def set_gravity(g_ms2: float) -> Dict[str, Any]:
    """Sets the acceleration due to gravity in m/s^2."""
    return model_manager.set_parameter('g', g_ms2)

@mcp.tool()
def set_air_density(rho_kgm3: float) -> Dict[str, Any]:
    """Sets the air density in kg/m^3."""
    return model_manager.set_parameter('rho', rho_kgm3)
'''

@mcp.tool()
def run_calculation() -> Dict[str, Any]:
    """
    Runs the power calculation using the currently set parameters.
    
    Make sure to set your desired parameters using the 'set_...' tools
    before running this calculation.
    """
    return model_manager.run_calculation()


if __name__ == "__main__":
    mcp.run(transport="streamable-http")