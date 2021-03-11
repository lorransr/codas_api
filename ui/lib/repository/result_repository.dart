import 'package:myanimate/model/codas_input.dart';
import 'package:myanimate/model/model_results.dart';
import 'package:myanimate/provider/api_provider.dart';

class ResultsRepository {
  ApiProvider _apiProvider = ApiProvider();

  Future<ModelResults> getRanking(CodasInput input) {
    return _apiProvider.getRanking(input);
  }
}
