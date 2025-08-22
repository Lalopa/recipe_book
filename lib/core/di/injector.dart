import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  getIt
    ..registerLazySingleton(Dio.new)
    ..registerFactory(MainCubit.new);
}
