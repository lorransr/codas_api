class ModelResults {
  final Map<String, dynamic> results;
  final String error;
  ModelResults(this.results, this.error);

  ModelResults.fromJson(Map<String, dynamic> json)
      : results = json["body"],
        error = "";

  ModelResults.withError(String errorValue)
      : results = {},
        error = errorValue;
}
