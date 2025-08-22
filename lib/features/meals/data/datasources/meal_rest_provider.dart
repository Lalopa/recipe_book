import 'package:dio/dio.dart';
import 'package:recipe_book/core/utils/api_constants.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  MealRemoteDataSourceImpl(this.dio);

  final Dio dio;

  @override
  Future<List<MealModel>> fetchByLetter(String letter) async {
    final res = await dio.get<Map<String, dynamic>>(
      ApiConstants.search,
      queryParameters: {'f': letter},
    );
    final list = res.data?['meals'] as List<dynamic>?;
    if (list == null) return [];
    return list
        .map(
          (e) => MealModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<MealModel>> searchMeals(String query) async {
    final res = await dio.get<Map<String, dynamic>>(
      ApiConstants.search,
      queryParameters: {'s': query},
    );
    final list = res.data?['meals'] as List<dynamic>?;
    if (list == null) return [];
    return list
        .map(
          (e) => MealModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
