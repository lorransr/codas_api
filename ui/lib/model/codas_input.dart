import 'package:codas_method/model/criteria.dart';

class CodasInput {
  List<Criteria> criterias;
  List<List<double>> alternatives;
  List<String> alternativesNames;
  double threshold;
  CodasInput(this.criterias, this.alternatives, this.alternativesNames,
      this.threshold);

  Map<String, dynamic> toJson() => {
        'criterias': criterias,
        'alternatives': alternatives,
        'threshold': threshold,
        'alternatives_names': alternativesNames
      };
}
