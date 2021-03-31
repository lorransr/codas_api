from typing import List,Optional
from enum import Enum
from pydantic import BaseModel,validator

class CriteriaType(str,Enum):
    cost = 'cost'
    benefit = 'benefit'

class Criteria(BaseModel):
    name: str
    type: CriteriaType
    weight: float

class CodasOutput(BaseModel):
    normalized_matrix: dict
    weighted_matrix: dict
    negative_ideal_solution: dict
    euclidian_distance: dict
    manhathan_distance: dict
    relative_assessment_matrix: dict
    assessment_score:dict

class CodasInput(BaseModel):
    criterias: List[Criteria]
    alternatives: List[List[float]]
    alternatives_names: Optional[List[str]]
    threshold: float

    class Config:
        schema_extra = {
            "example": {
                "criterias": [
                    {
                        "name":"load_capacity",
                        "type":"benefit",
                        "weight":0.036
                    },
                    {
                        "name":"repeatability",
                        "type":"cost",
                        "weight":0.192
                    },
                    {
                        "name":"maximum_tip_speed",
                        "type":"benefit",
                        "weight":0.326
                    },
                    {
                        "name":"memory_capacity",
                        "type":"benefit",
                        "weight":0.326
                    },                    
                    {
                        "name":"manipulator_reach",
                        "type":"benefit",
                        "weight":0.120
                    }

                ],
                "alternatives": [
                    [60.000, 0.400, 2540.000, 500.000, 990.000],
                    [6.350, 0.150, 1016.000, 3000.000, 1041.000],
                    [6.800, 0.100, 1727.200, 1500.000, 1676.000],
                    [10.000, 0.200, 1000.000, 2000.000, 965.000],
                    [2.500, 0.100, 560.000, 500.000, 915.000],
                    [4.500, 0.080, 1016.000, 350.000, 508.000],
                    [3.000, 0.100, 1778.000, 1000.000, 920.000]],
                "threshold": 0.02,
            }
        }

#w = [0.036, 0.192, 0.326, 0.326, 0.120]
#benefit_criterias = ["load_capacity","maximum_tip_speed","memory_capacity","manipulator_reach"]
#cost_criterias = ["repeatability"]
    @validator("alternatives")
    def alternatives_should_have_same_size(cls,v,values):
        sizes = []
        for a in v:
            sizes.append(len(a))
        print(len(set(sizes)))
        if len(set(sizes)) != 1:
            print("alternatives should have same size")
            raise ValueError("alternatives should have same size")
        elif "criterias" not in values:
            print("criterias should be provided")
            raise ValueError("criterias should be provided")
        elif sizes[0] != len(values["criterias"]):
            print("alternatives and criterias should have same length")
            raise ValueError("alternatives and criterias should have same length")
        else:
            return v

    @validator("threshold")
    def threshold_should_be_small(cls,v):
        assert v >= 0.01 and v <=0.05, "threshold should be between 0.01 and 0.05"
        return v

    @validator("criterias")
    def criteria_weights_should_add_to_one(cls,v):
        assert sum([c.weight for c in v]) == 1, "criterias weights should add up to 1"
        return v

    @validator("alternatives_names")
    def alternatives_names_should_have_same_len_as_alternatives_vector(cls,v,values):
        if v == None:
            return v
        elif "alternatives" not in values:
            print("alternatives should be provided")
            raise ValueError("alternatives should be provided")
        elif len(v) != len(values["alternatives"]):
            raise ValueError("alternatives len should have the same len of an alternative vector")
        else:
            return v
