import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/core/di/dio_config.dart';
import 'package:recipe_book/core/utils/api_constants.dart';

void main() {
  group('DioConfig', () {
    group('createDio', () {
      test('should create Dio instance successfully', () {
        final dio = DioConfig.createDio();

        expect(dio, isA<Dio>());
        expect(dio, isNotNull);
      });

      test('should create Dio with correct base URL', () {
        final dio = DioConfig.createDio();

        expect(dio.options.baseUrl, equals(ApiConstants.baseUrl));
      });

      test('should create Dio with correct timeout configuration', () {
        final dio = DioConfig.createDio();

        expect(dio.options.connectTimeout, equals(const Duration(seconds: 30)));
        expect(dio.options.receiveTimeout, equals(const Duration(seconds: 30)));
        expect(dio.options.sendTimeout, equals(const Duration(seconds: 30)));
      });

      test('should create Dio with correct headers', () {
        final dio = DioConfig.createDio();

        expect(dio.options.headers['Content-Type'], equals('application/json'));
        expect(dio.options.headers['Accept'], equals('application/json'));
      });

      test('should create Dio with logging interceptor', () {
        final dio = DioConfig.createDio();

        expect(dio.interceptors, isNotEmpty);
        // Verificar que tenga al menos el interceptor de logging
        final hasLoggingInterceptor = dio.interceptors.any(
          (interceptor) => interceptor.runtimeType.toString().contains('LoggingInterceptor'),
        );
        expect(hasLoggingInterceptor, isTrue);
      });
    });

    group('LoggingInterceptor', () {
      test('should handle onRequest without throwing', () {
        final dio = DioConfig.createDio();
        final interceptor = dio.interceptors.first;

        final requestOptions = RequestOptions(
          path: '/test',
          method: 'GET',
          queryParameters: {'param': 'value'},
        );

        expect(() {
          interceptor.onRequest(requestOptions, RequestInterceptorHandler());
        }, returnsNormally);
      });

      test('should handle onError without throwing', () {
        final dio = DioConfig.createDio();
        final interceptor = dio.interceptors.first;

        final requestOptions = RequestOptions(path: '/test');
        final error = DioException(
          requestOptions: requestOptions,
          response: Response(
            requestOptions: requestOptions,
            statusCode: 500,
            data: 'Internal Server Error',
          ),
          message: 'Internal Server Error',
        );

        expect(() {
          final customHandler = _CustomErrorInterceptorHandler();
          interceptor.onError(error, customHandler);
        }, returnsNormally);
      });
    });
  });
}

class _CustomErrorInterceptorHandler extends ErrorInterceptorHandler {
  @override
  void next(DioException error) {}
}
