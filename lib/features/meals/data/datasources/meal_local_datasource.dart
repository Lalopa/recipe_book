import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

abstract class MealLocalDataSource {
  Future<List<MealModel>?> getCachedMealsByLetter(String letter);
  Future<void> cacheMealsByLetter(String letter, List<MealModel> meals);
}

class MealLocalDataSourceImpl implements MealLocalDataSource {
  final ObjectBoxCacheManager _cache = ObjectBoxCacheManager.instance;

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
}
