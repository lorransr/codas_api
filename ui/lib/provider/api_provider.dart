import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:codas_method/model/codas_input.dart';
import 'package:codas_method/model/model_results.dart';

class ApiProvider {
  final String _baseUrl = " https://vprvdbyhz1.execute-api.us-east-2.amazonaws.com/prod"
  final String _endpoint = "$_baseUrl/codas/";
  final Dio _dio =
      Dio(BaseOptions(headers: {"Access-Control-Allow-Origin": "*"}));

  Future<ModelResults> getRanking(CodasInput input) async {
    try {
      Response response = await _dio.post(_endpoint, data: jsonEncode(input));
      print("success");
      return ModelResults.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ModelResults.withError("$error");
    }
  }
}
