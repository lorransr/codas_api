import 'package:codas_method/model/codas_input.dart';
import 'package:codas_method/model/model_results.dart';
import 'package:codas_method/provider/api_provider.dart';

class ResultsRepository {
  ApiProvider _apiProvider = ApiProvider();

  Future<ModelResults> getRanking(CodasInput input) {
    return _apiProvider.getRanking(input);
  }
}
