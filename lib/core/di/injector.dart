import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:recipe_book/core/di/dio_config.dart';

@module
abstract class AppModule {
  @lazySingleton
  Dio get dio => DioConfig.createDio();
}
