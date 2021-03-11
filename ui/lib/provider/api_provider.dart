import 'package:dio/dio.dart';
import 'package:myanimate/model/codas_input.dart';
import 'package:myanimate/model/model_results.dart';

class ApiProvider {
  final String _endpoint = "172.240.0.0/24:8000/codas/";
  final Dio _dio = Dio();

  Future<ModelResults> getRanking(CodasInput input) async {
    try {
      Response response = await _dio.post(_endpoint, data: input.toJson());
      return ModelResults.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ModelResults.withError("$error");
    }
  }
}
