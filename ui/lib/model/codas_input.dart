import 'package:myanimate/model/criteria.dart';

class CodasInput {
  List<Criteria> criterias;
  List<List<double>> alternatives;
  double threshold;
  CodasInput(this.criterias, this.alternatives, this.threshold);

  Map<String, dynamic> toJson() => {
        'criterias': criterias,
        'alternatives': alternatives,
        'threshold': threshold,
      };
}
