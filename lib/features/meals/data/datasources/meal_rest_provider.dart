import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:recipe_book/core/error/error.dart';
import 'package:recipe_book/core/utils/api_constants.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

@Injectable(as: MealRemoteDataSource)
class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  MealRemoteDataSourceImpl(this.dio);

  final Dio dio;

  @override
  Future<List<MealModel>> fetchByLetter(String letter) async {
    try {
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
    } on DioException catch (e) {
      throw FailureMapper.mapExceptionToFailure(e);
    } on FormatException catch (_) {
      throw const ParsingFailure('Error processing meals by letter response');
    } catch (e) {
      throw FailureMapper.mapExceptionToFailure(e);
    }
  }

  @override
  Future<List<MealModel>> searchMeals(String query) async {
    try {
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
    } on DioException catch (e) {
      throw FailureMapper.mapExceptionToFailure(e);
    } on FormatException catch (_) {
      throw const ParsingFailure('Error processing meal search response');
    } catch (e) {
      throw FailureMapper.mapExceptionToFailure(e);
    }
  }
}
