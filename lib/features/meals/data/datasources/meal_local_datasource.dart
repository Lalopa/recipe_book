import 'package:injectable/injectable.dart';
import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
import 'package:recipe_book/core/error/error.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

abstract class MealLocalDataSource {
  Future<List<MealModel>?> getCachedMealsByLetter(String letter);

  Future<void> cacheMealsByLetter(String letter, List<MealModel> meals);

  Future<List<MealModel>?> getCachedSearchResults(String query);

  Future<void> cacheSearchResults(String query, List<MealModel> meals);
}

@Injectable(as: MealLocalDataSource)
class MealLocalDataSourceImpl implements MealLocalDataSource {
  MealLocalDataSourceImpl(this._cache);
  final ObjectBoxCacheManager _cache;

  @override
  Future<List<MealModel>?> getCachedMealsByLetter(String letter) async {
    try {
      return _cache.getCachedMeals(letter);
    } on Exception catch (_) {
      throw const LocalDatabaseFailure('Database not initialized');
    }
  }

  @override
  Future<void> cacheMealsByLetter(String letter, List<MealModel> meals) async {
    try {
      await _cache.cacheMeals(
        letter,
        meals,
        ttl: const Duration(minutes: 30),
      );
    } on Exception catch (_) {
      throw const LocalDatabaseFailure('Database not initialized');
    }
  }

  @override
  Future<List<MealModel>?> getCachedSearchResults(String query) async {
    try {
      final normalizedQuery = normalizeQuery(query);
      return _cache.getCachedMeals(normalizedQuery);
    } on Exception catch (_) {
      throw const LocalDatabaseFailure('Database not initialized');
    }
  }

  @override
  Future<void> cacheSearchResults(String query, List<MealModel> meals) async {
    try {
      final normalizedQuery = normalizeQuery(query);
      await _cache.cacheMeals(
        normalizedQuery,
        meals,
        ttl: const Duration(hours: 1), // Cache por 1 hora
      );
    } on Exception catch (_) {
      throw const LocalDatabaseFailure('Database not initialized');
    }
  }

  String normalizeQuery(String query) {
    return query.trim().toLowerCase();
  }
}
