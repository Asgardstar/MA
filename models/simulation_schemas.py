
from pydantic import BaseModel, Field
from typing import List, Dict, Any

class SimulationInstance(BaseModel):
    model_id: str = Field(description="The unique identifier of the simulation model to execute.")
    inputs: Dict[str, Any] = Field(description="A dictionary of input parameters and their values for the model.")

class ExecutionPayload(BaseModel):
    simulations: List[SimulationInstance] = Field(description="A list containing a single simulation instance to execute.")
    confirmed: bool = Field(description="Set to false for the first execution attempt to handle confirmation. Set to true if user has already confirmed.")

