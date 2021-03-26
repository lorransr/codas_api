from fastapi import FastAPI
from fastapi.logger import logger 
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel,validator
from typing import List
from enum import Enum
import pandas as pd
import codas_method
from model import CodasInput,CriteriaType


app = FastAPI()

origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/codas/")
def calculate_codas(input:CodasInput):
    print("received input")
    print("input dict: {}".format(input.dict()))
    print("pre processing")
    m_raw = pd.DataFrame(input.alternatives,columns=[c.name for c in input.criterias])
    weights = pd.Series([c.weight for c in input.criterias],index = [c.name for c in input.criterias])
    alternatives = [ "a_" + str(i) for i in range(1,len(m_raw)+1)]
    benefit_criteria = [c.name for c in input.criterias if c.type == CriteriaType.benefit]
    cost_criteria = [c.name for c in input.criterias if c.type == CriteriaType.cost]
    print("calculating codas...")
    results = (
        codas_method.calculate_codas(
            m_raw,alternatives,weights,benefit_criteria,cost_criteria,input.threshold))
    
    print("sending results")
    print("assessment_score: {}".format(results.dict()))
    return results.dict()