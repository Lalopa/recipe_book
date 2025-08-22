import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';

part 'meal_model.freezed.dart';
part 'meal_model.g.dart';

@freezed
class MealModel with _$MealModel {
  const factory MealModel({
    @JsonKey(name: 'idMeal') required String id,
    @JsonKey(name: 'strMeal') required String name,
    @JsonKey(name: 'strMealThumb') required String? thumbnail,
    @JsonKey(name: 'strCategory') @Default('') String category,
    @JsonKey(name: 'strInstructions') @Default('') String instructions,
    @JsonKey(
      fromJson: _ingredientsFromJson,
      readValue: _readWholeJson,
    )
    @Default(<String, String>{})
    Map<String, String> ingredients,
  }) = _MealModel;

  factory MealModel.fromJson(
    Map<String, dynamic> json,
  ) => _$MealModelFromJson(json);
}

Object? _readWholeJson(Map<dynamic, dynamic> json, String _) => json;

Map<String, String> _ingredientsFromJson(Object? json) {
  final map = <String, String>{};
  if (json is! Map) return map;

  for (var i = 1; i <= 20; i++) {
    final ing = (json['strIngredient$i'] ?? '').toString().trim();
    final mea = (json['strMeasure$i'] ?? '').toString().trim();
    if (ing.isNotEmpty) {
      map[ing] = mea;
    }
  }
  return map;
}

extension MealModelMapper on MealModel {
  Meal toEntity() => Meal(
    id: id,
    name: name,
    thumbnail: thumbnail,
    category: category,
    instructions: instructions,
    ingredients: ingredients,
  );
}
