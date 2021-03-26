import 'codas_output.dart';

class ModelResults {
  final CodasOutput results;
  final String error;
  ModelResults(this.results, this.error);

  ModelResults.fromJson(Map<String, dynamic> json)
      : results = CodasOutput.fromJson(json),
        error = "";

  ModelResults.withError(String errorValue)
      : results = CodasOutput.withError(),
        error = errorValue;
}
