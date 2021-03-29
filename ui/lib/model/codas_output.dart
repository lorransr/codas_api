class CodasOutput {
  final Map<String, dynamic> normalizedMatrix;
  final Map<String, dynamic> weightedMatrix;
  final Map<String, dynamic> negativeIdealSolution;
  final Map<String, dynamic> euclidianDistance;
  final Map<String, dynamic> manhathanDistance;
  final Map<String, dynamic> relativeAssessmentMatrix;
  final Map<String, dynamic> assessmentScore;

  CodasOutput(
      this.normalizedMatrix,
      this.weightedMatrix,
      this.negativeIdealSolution,
      this.euclidianDistance,
      this.manhathanDistance,
      this.relativeAssessmentMatrix,
      this.assessmentScore);

  CodasOutput.fromJson(Map<String, dynamic> json)
      : normalizedMatrix = json["normalized_matrix"],
        weightedMatrix = json["weighted_matrix"],
        negativeIdealSolution = json["negative_ideal_solution"],
        euclidianDistance = json["euclidian_distance"],
        manhathanDistance = json["manhathan_distance"],
        relativeAssessmentMatrix = json["relative_assessment_matrix"],
        assessmentScore = json["assessment_score"];

  CodasOutput.withError()
      : normalizedMatrix = {},
        weightedMatrix = {},
        negativeIdealSolution = {},
        euclidianDistance = {},
        manhathanDistance = {},
        relativeAssessmentMatrix = {},
        assessmentScore = {};

  Map<String, dynamic> toJson() => {
        "normalized_matrix": normalizedMatrix,
        "weighted_matrix": normalizedMatrix,
        "negative_ideal_solution": negativeIdealSolution,
        "euclidian_distance": euclidianDistance,
        "manhathan_distance": manhathanDistance,
        "relative_assessment_matrix": relativeAssessmentMatrix,
        "assessment_score": assessmentScore
      };
}
