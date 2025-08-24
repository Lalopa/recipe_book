import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:recipe_book/core/models/objectbox/meal_objectbox_model.dart';
import 'package:recipe_book/core/models/objectbox/search_cache_objectbox_model.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';
import 'package:recipe_book/objectbox.g.dart';

class ObjectBoxCacheManager {
  ObjectBoxCacheManager();

  late Box<MealObjectBoxModel> _mealBox;
  late Box<SearchObjectBoxModel> _searchCacheBox;

  void initialize(Store store) {
    _mealBox = store.box<MealObjectBoxModel>();
    _searchCacheBox = store.box<SearchObjectBoxModel>();
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

        final existing = _mealBox
            .query(MealObjectBoxModel_.mealId.equals(meal.id))
            .build()
            .findFirst();
        if (existing != null) {
          objectBoxModel
            ..id = existing.id
            // Preservar el estado de favorito existente
            ..isFavorite = existing.isFavorite;
        }

        _mealBox.put(objectBoxModel);
      }

      final searchEntry = SearchObjectBoxModel(
        searchKey: key,
        dataJson: jsonEncode(meals.map((m) => m.toJson()).toList()),
        timestamp: DateTime.now(),
        expiresAt: ttl != null
            ? DateTime.now().add(ttl)
            : DateTime.now().add(const Duration(hours: 1)),
      );

      final existingSearch = _searchCacheBox
          .query(SearchObjectBoxModel_.searchKey.equals(key))
          .build()
          .findFirst();
      if (existingSearch != null) {
        searchEntry.id = existingSearch.id;
      }

      _searchCacheBox.put(searchEntry);
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error caching meals: $e');
      }
    }
  }

  Future<List<MealModel>?> getCachedMeals(String key) async {
    try {
      final searchEntry = _searchCacheBox
          .query(SearchObjectBoxModel_.searchKey.equals(key))
          .build()
          .findFirst();

      if (searchEntry == null || searchEntry.isExpired) {
        if (searchEntry?.isExpired ?? false) {
          _searchCacheBox.remove(searchEntry!.id);
        }
        return null;
      }

      final mealsJson = jsonDecode(searchEntry.dataJson) as List;
      final mealIds = mealsJson
          .map((json) => (json as Map<String, dynamic>)['idMeal'] as String)
          .toList();

      final meals = <MealModel>[];
      for (final mealId in mealIds) {
        final cachedMeal = await getCachedMeal(mealId);
        if (cachedMeal != null) {
          meals.add(cachedMeal);
        }
      }

      return meals;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error getting cached meals: $e');
      }
      return null;
    }
  }

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

  // Métodos para manejar favoritos
  Future<void> toggleFavorite(String mealId) async {
    try {
      final meal = _mealBox
          .query(MealObjectBoxModel_.mealId.equals(mealId))
          .build()
          .findFirst();
      if (meal != null) {
        meal.isFavorite = !meal.isFavorite;
        _mealBox.put(meal);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error toggling favorite: $e');
      }
    }
  }

  Future<void> setFavorite({
    required String mealId,
    required bool isFavorite,
  }) async {
    try {
      final meal = _mealBox
          .query(MealObjectBoxModel_.mealId.equals(mealId))
          .build()
          .findFirst();
      if (meal != null) {
        meal.isFavorite = isFavorite;
        _mealBox.put(meal);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error setting favorite: $e');
      }
    }
  }

  Future<List<MealModel>> getFavoriteMeals() async {
    try {
      final favoriteMeals = _mealBox
          .query(MealObjectBoxModel_.isFavorite.equals(true))
          .build()
          .find();

      return favoriteMeals.map((meal) {
        final mealModel = meal.toMealModel();
        return MealModel.fromJson(mealModel.toJson());
      }).toList();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error getting favorite meals: $e');
      }
      return [];
    }
  }

  Future<bool> isFavorite(String mealId) async {
    try {
      final meal = _mealBox
          .query(MealObjectBoxModel_.mealId.equals(mealId))
          .build()
          .findFirst();
      return meal?.isFavorite ?? false;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error checking favorite status: $e');
      }
      return false;
    }
  }

  // Métodos para limpiar el cache
  Future<void> clearAllCache() async {
    try {
      _mealBox.removeAll();
      _searchCacheBox.removeAll();
      if (kDebugMode) {
        print('Cache limpiado completamente');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error limpiando cache: $e');
      }
    }
  }

  Future<void> clearExpiredCache() async {
    try {
      final now = DateTime.now();

      // Limpiar comidas expiradas
      final allMeals = _mealBox.getAll();
      for (final meal in allMeals) {
        if (meal.expiresAt != null && meal.expiresAt!.isBefore(now)) {
          _mealBox.remove(meal.id);
        }
      }

      // Limpiar búsquedas expiradas
      final allSearches = _searchCacheBox.getAll();
      for (final search in allSearches) {
        if (search.expiresAt.isBefore(now)) {
          _searchCacheBox.remove(search.id);
        }
      }

      if (kDebugMode) {
        print('Cache expirado limpiado');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error limpiando cache expirado: $e');
      }
    }
  }

  Future<void> clearSearchCache() async {
    try {
      _searchCacheBox.removeAll();
      if (kDebugMode) {
        print('Cache de búsquedas limpiado');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error limpiando cache de búsquedas: $e');
      }
    }
  }

  Future<List<dynamic>?> getCachedSearchResults(String query) async {
    try {
      final normalizedQuery = normalizeQuery(query);
      final searchEntry = _searchCacheBox
          .query(SearchObjectBoxModel_.searchKey.equals(normalizedQuery))
          .build()
          .findFirst();

      if (searchEntry == null || searchEntry.isExpired) {
        if (searchEntry?.isExpired ?? false) {
          _searchCacheBox.remove(searchEntry!.id);
        }
        return null;
      }

      return jsonDecode(searchEntry.dataJson) as List;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error getting cached search results: $e');
      }
      return null;
    }
  }

  void _cleanExpiredMeals() {
    try {
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

  String normalizeQuery(String query) {
    return query.trim().toLowerCase();
  }
}
