import 'dart:convert';

import 'package:chuck/chuckResponse.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ChuckService {
  final String apiBaseUrl = 'https://api.chucknorris.io/jokes/';
  final BaseOptions options = BaseOptions(
      responseType: ResponseType.json,
      receiveTimeout: 5,
      sendTimeout: 5,
      
    );
  Future<ChuckResponse> getJokeRandom() async {
    Dio dio = Dio(options);
    try {
      Response response = await dio
          .get(apiBaseUrl + '/random');
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(response.data.toString());
        debugPrint(json.encode(response.data));
        ChuckResponse responseJson =
            ChuckResponse.fromMap(response.data);
        return responseJson;
      }
      throw Exception('Response unknown');
    } on DioError catch (exception) {
      processDioError(exception);
    }
  }

  Future<ChuckResponse> getJokeRandomByCategory(String category) async {
    Dio dio = Dio(options);
    try {
      debugPrint(apiBaseUrl + '/random?category=' + category);
      Response response = await dio
          .get(apiBaseUrl + '/random?category=' + category);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(response.data.toString());
        debugPrint(json.encode(response.data));
        ChuckResponse responseJson =
            ChuckResponse.fromMap(response.data);
        return responseJson;
      }
      throw Exception('Response unknown');
    } on DioError catch (exception) {
      processDioError(exception);
    }
  }

  Future<List<String>> getCategories() async {
    Dio dio = Dio(options);
    try {
      Response response = await dio
          .get(apiBaseUrl + '/categories');
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(json.encode(response.data));
        List<String> salida = List<String>();
        for (var a in response.data) {
          salida.add(a.toString());
        }
        return salida;
      }
      throw Exception('Response unknown');
    } on DioError catch (exception) {
      processDioError(exception);
    }
  }

  void processDioError(DioError exception) {
  if (exception == null || exception.toString().contains('SocketException')) {
    throw new Exception("Network Error SocketException");
  } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
      exception.type == DioErrorType.CONNECT_TIMEOUT) {
    throw new Exception(
        "Could'nt connect, please ensure you have a stable network.");
  }
  throw Exception("Network Error");
}
}