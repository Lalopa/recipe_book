import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:recipe_book/core/di/objectbox_config.dart';
import 'package:recipe_book/core/models/objectbox/meal_objectbox_model.dart';
import 'package:recipe_book/core/models/objectbox/search_cache_objectbox_model.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';
import 'package:recipe_book/objectbox.g.dart';

class ObjectBoxCacheManager {
  ObjectBoxCacheManager._();

  static final ObjectBoxCacheManager _instance = ObjectBoxCacheManager._();
  static ObjectBoxCacheManager get instance => _instance;

  Box<MealObjectBoxModel>? _mealBox;
  Box<SearchObjectBoxModel>? _searchCacheBox;

  Box<MealObjectBoxModel> get _mealBoxInstance {
    _mealBox ??= ObjectBoxConfig.store.box<MealObjectBoxModel>();
    return _mealBox!;
  }

  Box<SearchObjectBoxModel> get _searchCacheBoxInstance {
    _searchCacheBox ??= ObjectBoxConfig.store.box<SearchObjectBoxModel>();
    return _searchCacheBox!;
  }

  Future<void> cacheMeals(
    String key,
    List<MealModel> meals, {
    Duration? ttl,
  }) async {
    try {
      _cleanExpiredMeals();

      for (final meal in meals) {
        final objectBoxModel = MealObjectBoxModel.fromMealModel(meal, ttl: ttl);

        final existing = _mealBoxInstance
            .query(MealObjectBoxModel_.mealId.equals(meal.id))
            .build()
            .findFirst();
        if (existing != null) {
          objectBoxModel.id = existing.id;
        }

        _mealBoxInstance.put(objectBoxModel);
      }

      final searchEntry = SearchObjectBoxModel(
        searchKey: key,
        dataJson: jsonEncode(meals.map((m) => m.toJson()).toList()),
        timestamp: DateTime.now(),
        expiresAt: ttl != null
            ? DateTime.now().add(ttl)
            : DateTime.now().add(const Duration(hours: 1)),
      );

      final existingSearch = _searchCacheBoxInstance
          .query(SearchObjectBoxModel_.searchKey.equals(key))
          .build()
          .findFirst();
      if (existingSearch != null) {
        searchEntry.id = existingSearch.id;
      }

      _searchCacheBoxInstance.put(searchEntry);
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error caching meals: $e');
      }
    }
  }

  Future<List<MealModel>?> getCachedMeals(String key) async {
    try {
      final searchEntry = _searchCacheBoxInstance
          .query(SearchObjectBoxModel_.searchKey.equals(key))
          .build()
          .findFirst();

      if (searchEntry == null || searchEntry.isExpired) {
        if (searchEntry?.isExpired ?? false) {
          _searchCacheBoxInstance.remove(searchEntry!.id);
        }
        return null;
      }

      final mealsJson = jsonDecode(searchEntry.dataJson) as List;
      return mealsJson
          .map((json) => MealModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error getting cached meals: $e');
      }
      return null;
    }
  }

  Future<MealModel?> getCachedMeal(String mealId) async {
    try {
      final meal = _mealBoxInstance
          .query(MealObjectBoxModel_.mealId.equals(mealId))
          .build()
          .findFirst();

      if (meal == null || meal.isExpired) {
        if (meal?.isExpired ?? false) {
          _mealBoxInstance.remove(meal!.id);
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
      final allMeals = _mealBoxInstance.query().build().find();
      final expiredMeals = <MealObjectBoxModel>[];

      for (final meal in allMeals) {
        if (meal.expiresAt != null && DateTime.now().isAfter(meal.expiresAt!)) {
          expiredMeals.add(meal);
        }
      }

      for (final meal in expiredMeals) {
        _mealBoxInstance.remove(meal.id);
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
