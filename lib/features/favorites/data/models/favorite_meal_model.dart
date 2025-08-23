import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recipe_book/features/favorites/domain/entities/favorite_meal.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

part 'favorite_meal_model.freezed.dart';
part 'favorite_meal_model.g.dart';

@freezed
class FavoriteMealModel with _$FavoriteMealModel {
  const factory FavoriteMealModel({
    required String id,
    required String name,
    required String? thumbnail,
    required String category,
    required String instructions,
    required Map<String, String> ingredients,
    required DateTime? addedAt,
  }) = _FavoriteMealModel;

  factory FavoriteMealModel.fromJson(Map<String, dynamic> json) => _$FavoriteMealModelFromJson(json);

  factory FavoriteMealModel.fromMealModel(MealModel meal) {
    return FavoriteMealModel(
      id: meal.id,
      name: meal.name,
      thumbnail: meal.thumbnail,
      category: meal.category,
      instructions: meal.instructions,
      ingredients: meal.ingredients,
      addedAt: DateTime.now(),
    );
  }
}

extension FavoriteMealModelMapper on FavoriteMealModel {
  FavoriteMeal toEntity() => FavoriteMeal(
    id: id,
    name: name,
    thumbnail: thumbnail,
    category: category,
    instructions: instructions,
    ingredients: ingredients,
    addedAt: addedAt,
  );
}
