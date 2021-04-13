from model import CodasOutput
import pandas as pd
import numpy as np
from typing import List
import logging

logger = logging.getLogger()

def normalize_codas(s:pd.Series,benefit_criteria = True)->pd.Series:
  if benefit_criteria:
    return s.apply(lambda x: x/(s.max()))
  else:
    return s.apply(lambda x: s.min()/x)

def comparison_matrix(s:pd.Series)->np.array:
  return s.values - s.values[:,None]

def calculate_codas(
    m_raw: pd.DataFrame,
    alternatives:List[str],
    weights: pd.Series,
    benefit_criteria: List[str],
    cost_criteria: List[str],
    threshold: float)->pd.Series:
    """calculate CODAS assessment score for alternatives

    Args:
        m_raw (str): raw dicision matrix
        alternatives (List[str]): name of the alternatives
        weights (pd.Series): criteria weights
        benefit_criteria (List[str]): list of benefit criterias
        cost_criteria (List[str]): list of cost criterias (complement to benefit criteria, could be an empty list)
        threshold (float): threshold factor (should be some small value between 0.01 and 0.05)

    Returns:
        pd.Series: assessment score for alternatives"""
    benefits = m_raw[benefit_criteria].apply(lambda x: normalize_codas(x))
    costs = m_raw[cost_criteria].apply(lambda x: normalize_codas(x,benefit_criteria=False))
    # step 2
    m_normalized = pd.concat([benefits,costs],axis=1)
    # step 3
    m_weighted = m_normalized * weights
    # step 4
    negative_ideal_solution = m_weighted.min()
    # step 5
    euclidian_distance = (
        m_weighted.apply(
            lambda x: np.linalg.norm(x - negative_ideal_solution)
            ,axis=1)
            )
    manhathan_distance = (
        m_weighted.apply(
            lambda x: (x - negative_ideal_solution).abs().sum()
            ,axis=1)
            )
    # step 6        
    euclidean_comparison = pd.DataFrame(
        comparison_matrix(euclidian_distance),
        index=alternatives,
        columns=alternatives
    )

    manhathan_comparison = pd.DataFrame(
        comparison_matrix(manhathan_distance),
        index=alternatives,
        columns=alternatives)

    threshold_matrix = ((euclidean_comparison.abs()<threshold)*1)

    relative_assesment_matrix = (
        euclidean_comparison + threshold_matrix * manhathan_comparison)
    # step 7
    assessment_score = relative_assesment_matrix.sum().sort_values(ascending=False)
    logger.info("assessment score: {}".format(assessment_score.to_dict()))
    output = CodasOutput(
        **{
            "normalized_matrix":m_normalized.to_dict(),
            "weighted_matrix":m_weighted.to_dict(),
            "negative_ideal_solution":negative_ideal_solution.to_dict(),
            "euclidian_distance":euclidian_distance.to_dict(),
            "manhathan_distance":manhathan_distance.to_dict(),
            "relative_assessment_matrix":relative_assesment_matrix.to_dict(),
            "assessment_score":assessment_score.to_dict()
        }
        )
    return output

if __name__ == "__main__":
    # calculate_codas()
    # working example
    data = {
    "load_capacity": [60,6.35,6.8,10,2.5,4.5,3],
    "maximum_tip_speed" : [0.4,0.15,0.10,0.2,0.10,0.08,0.1],
    "repeatability" : [2540,1016,1727.2,1000,560,1016,1778],
    "memory_capacity" : [500,3000,1500,2000,500,350,1000],
    "manipulator_reach" : [990,1041,1676,965,915,508,920]
    }
    m_raw = pd.DataFrame(data)
    
    alternatives = [ "a_" + str(i) for i in range(1,len(m_raw)+1)]
    m_raw.index = alternatives

    criterias = list(m_raw.columns)
    w = np.ones(len(criterias)) * 1/len(criterias)
    assert len(w) == len(criterias), "weights should match criteria lenght"
    assert sum(w) == 1, "sum of weights should be 1"
    weights = pd.Series(w,index=criterias)

    benefit_criteria = ["load_capacity","maximum_tip_speed","memory_capacity","manipulator_reach"]
    cost_criteria = ["repeatability"]
    threshold = 0.02
    results = calculate_codas(m_raw,alternatives,weights,benefit_criteria,cost_criteria,threshold)
    for r in results:
        logger.info("result: {}".format(r.to_dict()))
