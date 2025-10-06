# test_matlab_call.py

import matlab.engine
import sys

def run_matlab_calculation():
    """
    Starts the MATLAB engine, calls the calculation function,
    and prints the result.
    """
    print("Starting MATLAB engine...")
    try:
        # Start a shared MATLAB session.
        # This can take a few moments.
        eng = matlab.engine.start_matlab()
        print("MATLAB engine started successfully.")

        # Add the current directory to MATLAB's path.
        # This ensures MATLAB can find the .m file.
        matlab_script_path = r'D:\OneDrive - Students RWTH Aachen University\MATLAB Models'
        eng.addpath(matlab_script_path, nargout=0)

        # --- Define Input Parameters ---
        # These are example values. You can change them.
        vehicle_speed_kph = 100.0  
        road_grade_percent = 2.0   
        vehicle_mass_kg = 1500.0   
        drag_coeff = 0.25         
        frontal_area_m2 = 2.2      
        rolling_res_coeff = 0.01   
        powertrain_eff = 0.9     
        g = 9.81                    
        rho = 1.225                 

        print("\nCalling MATLAB function 'calculate_electric_power' with example data...")

        # Call the MATLAB function.
        # Python floats are automatically converted to MATLAB doubles.
        # The 'nargout=1' argument specifies that we expect one return value.
        power_output = eng.calculate_electric_power(
            vehicle_speed_kph,
            road_grade_percent,
            vehicle_mass_kg,
            drag_coeff,
            frontal_area_m2,
            rolling_res_coeff,
            powertrain_eff,
            g,
            rho,
            nargout=1
        )

        print(f"\nCalculation successful!")
        print(f"Required Electric Power: {power_output:.2f} Watts")

    except matlab.engine.EngineError as e:
        print(f"An error occurred with the MATLAB engine: {e}", file=sys.stderr)
    except Exception as e:
        print(f"An unexpected error occurred: {e}", file=sys.stderr)
    finally:
        # Ensure the engine is stopped.
        if 'eng' in locals() and eng:
            print("\nStopping MATLAB engine.")
            eng.quit()

if __name__ == "__main__":
    run_matlab_calculation()