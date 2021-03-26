class CodasOutput {
  final Map<String, dynamic> normalized_matrix;
  final Map<String, dynamic> weighted_matrix;
  final Map<String, dynamic> negative_ideal_solution;
  final Map<String, dynamic> euclidian_distance;
  final Map<String, dynamic> manhathan_distance;
  final Map<String, dynamic> relative_assessment_matrix;
  final Map<String, dynamic> assessment_score;

  CodasOutput(
      this.normalized_matrix,
      this.weighted_matrix,
      this.negative_ideal_solution,
      this.euclidian_distance,
      this.manhathan_distance,
      this.relative_assessment_matrix,
      this.assessment_score);

  CodasOutput.fromJson(Map<String, dynamic> json)
      : normalized_matrix = json["normalized_matrix"],
        weighted_matrix = json["weighted_matrix"],
        negative_ideal_solution = json["negative_ideal_solution"],
        euclidian_distance = json["euclidian_distance"],
        manhathan_distance = json["manhathan_distance"],
        relative_assessment_matrix = json["relative_assessment_matrix"],
        assessment_score = json["assessment_score"];

  CodasOutput.withError()
      : normalized_matrix = {},
        weighted_matrix = {},
        negative_ideal_solution = {},
        euclidian_distance = {},
        manhathan_distance = {},
        relative_assessment_matrix = {},
        assessment_score = {};
}
