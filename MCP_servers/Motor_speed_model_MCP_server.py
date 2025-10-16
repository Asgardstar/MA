
import matlab.engine
import sys
from mcp.server.fastmcp import FastMCP
from typing import Union, Dict, Any
import os
from dotenv import load_dotenv

load_dotenv()

# Start MATLAB Engine ---
print("Starting MATLAB engine... This may take a moment.")
try:
    eng = matlab.engine.start_matlab()
    matlab_script_path = os.environ.get("MOTOR_SPEED_MODEL_PATH")
    eng.addpath(matlab_script_path, nargout=0)
    print("MATLAB engine started successfully.")
except Exception as e:
    print(f"Fatal: Could not start MATLAB engine. {e}", file=sys.stderr)
    sys.exit(1)

# Define the Stateful Wrapper Class ---
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

# Create Server and Model Manager Instance ---
mcp = FastMCP(
    " Vehicle Power Calculator",
    port=8002
)
model_manager = MatlabModelManager(eng)


# Create MCP Tools that Use the Manager ---

@mcp.tool()
def get_all_parameters() -> Dict[str, float]:
    """Query all current model parameters and their values of the motor speed model."""
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
    Sets one or more vehicle model parameters of the motor speed model in a single call.

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


@mcp.tool()
def run_calculation() -> Dict[str, Any]:
    """
    Runs the power calculation of the motor speed model using the currently set parameters.
    
    Make sure to set your desired parameters using the 'set_...' tools
    before running this calculation.
    """
    return model_manager.run_calculation()


if __name__ == "__main__":
    mcp.run(transport="streamable-http")