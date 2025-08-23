import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:recipe_book/core/utils/api_constants.dart';

class DioConfig {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      _LoggingInterceptor(),
    ]);

    return dio;
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('REQUEST[${options.method}] => PATH: ${options.path}');
      print(
        'REQUEST[${options.method}] => QUERY PARAMETERS: ${options.queryParameters}',
      );
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
      print('ERROR MESSAGE: ${err.message}');
    }

    super.onError(err, handler);
  }
}
