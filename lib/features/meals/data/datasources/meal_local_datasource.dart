import 'package:injectable/injectable.dart';
import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
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
    return _cache.getCachedMeals(letter);
  }

  @override
  Future<void> cacheMealsByLetter(String letter, List<MealModel> meals) async {
    await _cache.cacheMeals(
      letter,
      meals,
      ttl: const Duration(minutes: 30),
    );
  }

  @override
  Future<List<MealModel>?> getCachedSearchResults(String query) async {
    final normalizedQuery = normalizeQuery(query);
    return _cache.getCachedMeals(normalizedQuery);
  }

  @override
  Future<void> cacheSearchResults(String query, List<MealModel> meals) async {
    final normalizedQuery = normalizeQuery(query);
    await _cache.cacheMeals(
      normalizedQuery,
      meals,
      ttl: const Duration(hours: 1), // Cache por 1 hora
    );
  }

  String normalizeQuery(String query) {
    return query.trim().toLowerCase();
  }
}
