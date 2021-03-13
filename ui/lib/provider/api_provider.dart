import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:myanimate/model/codas_input.dart';
import 'package:myanimate/model/model_results.dart';

class ApiProvider {
  final String _endpoint = "http://127.0.0.1:8000/codas/";
  final Dio _dio =
      Dio(BaseOptions(headers: {"Access-Control-Allow-Origin": "*"}));

  Future<ModelResults> getRanking(CodasInput input) async {
    try {
      Response response = await _dio.post(_endpoint, data: jsonEncode(input));
      return ModelResults.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ModelResults.withError("$error");
    }
  }
}
