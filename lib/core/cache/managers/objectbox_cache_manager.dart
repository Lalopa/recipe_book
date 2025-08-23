import 'package:flutter/foundation.dart';
import 'package:recipe_book/core/models/objectbox/meal_objectbox_model.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';
import 'package:recipe_book/objectbox.g.dart';

class ObjectBoxCacheManager {
  ObjectBoxCacheManager._();

  static final ObjectBoxCacheManager _instance = ObjectBoxCacheManager._();
  static ObjectBoxCacheManager get instance => _instance;

  late Box<MealObjectBoxModel> _mealBox;

  void initialize(Store store) {
    _mealBox = store.box<MealObjectBoxModel>();
  }

  Future<void> cacheMeals(
    String key,
    List<MealModel> meals, {
    Duration? ttl,
  }) async {
    try {
      // Limpiar cache expirado
      _cleanExpiredMeals();

      // Convertir y guardar cada meal
      for (final meal in meals) {
        final objectBoxModel = MealObjectBoxModel.fromMealModel(meal, ttl: ttl);

        // Verificar si ya existe y actualizar
        final existing = _mealBox
            .query(MealObjectBoxModel_.mealId.equals(meal.id))
            .build()
            .findFirst();
        if (existing != null) {
          objectBoxModel.id = existing.id;
        }

        _mealBox.put(objectBoxModel);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error caching meals: $e');
      }
    }
  }

  /// Obtiene un meal específico por ID
  Future<MealModel?> getCachedMeal(String mealId) async {
    try {
      final meal = _mealBox
          .query(MealObjectBoxModel_.mealId.equals(mealId))
          .build()
          .findFirst();

      if (meal == null || meal.isExpired) {
        if (meal?.isExpired ?? false) {
          _mealBox.remove(meal!.id);
        }
        return null;
      }

      return meal.toMealModel();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error getting cached meal: $e');
      }
      return null;
    }
  }

  void _cleanExpiredMeals() {
    try {
      // Obtener todos los meals y filtrar los expirados manualmente
      final allMeals = _mealBox.query().build().find();
      final expiredMeals = <MealObjectBoxModel>[];

      for (final meal in allMeals) {
        if (meal.expiresAt != null && DateTime.now().isAfter(meal.expiresAt!)) {
          expiredMeals.add(meal);
        }
      }

      for (final meal in expiredMeals) {
        _mealBox.remove(meal.id);
      }

      if (kDebugMode) {
        if (expiredMeals.isNotEmpty) {
          print('Cleaned ${expiredMeals.length} expired meals');
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error cleaning expired meals: $e');
      }
    }
  }
}
