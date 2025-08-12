# 1. Import necessary libraries
from OMPython import ModelicaSystem
import numpy as np
import sys
import time

# 2. Define model path and name
model_path = "K:/MasterThesis/OM_models/MassSpringDamper.mo"
model_name = "MassSpringDamper"

try:
    # 3. Create a ModelicaSystem object
    print(f"Loading model '{model_name}' from '{model_path}'...")
    mod = ModelicaSystem(model_path, model_name)
    print("Model loaded successfully.\n")

    # 4. Build the model before simulation
    mod.buildModel()
    print("Model built successfully.\n")

    # 5. Simulate and get solutions
    print("Executing simulation...")
    mod.simulate()
    print("Simulation finished.")
    
    print("Reading simulation results for ['time', 'x', 'v']...")
    solutions = mod.getSolutions(["time", "x", "v"])

    # Store the data directly into numpy arrays
    if solutions is not None:
        time_values = solutions[0]
        x_values = solutions[1]
        v_values = solutions[2]
        print("Successfully retrieved data.\n")
    else:
        print("Solutions Type is None!")

    # 6. Interactive loop to query values
    while True:
        try:
            t_input_str = input("Enter time t (or 'exit' to quit): ")
            if t_input_str.lower() == 'exit':
                break

            t = float(t_input_str)

            if not (time_values[0] <= t <= time_values[-1]):
                print(f"Error: Time {t} is outside the simulation range [{time_values[0]}, {time_values[-1]}]")
                continue

            x_at_t = np.interp(t, time_values, x_values)
            v_at_t = np.interp(t, time_values, v_values)
            print(f"--> At time t = {t}, the value of x is: {x_at_t}, the value of v is: {v_at_t}\n")

        except ValueError:
            print("Invalid input. Please enter a number or 'exit'.\n")
        except Exception as e:
            print(f"An error occurred: {e}\n")

except Exception as e:
    print("\n--- A  error occurred ---")
    print(e)
    sys.exit()

print("Exiting program.")