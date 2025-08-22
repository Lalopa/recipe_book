// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealModelImpl _$$MealModelImplFromJson(Map<String, dynamic> json) =>
    _$MealModelImpl(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbnail: json['strMealThumb'] as String?,
      category: json['strCategory'] as String? ?? '',
      instructions: json['strInstructions'] as String? ?? '',
      ingredients: _readWholeJson(json, 'ingredients') == null
          ? const <String, String>{}
          : _ingredientsFromJson(_readWholeJson(json, 'ingredients')),
    );

Map<String, dynamic> _$$MealModelImplToJson(_$MealModelImpl instance) =>
    <String, dynamic>{
      'idMeal': instance.id,
      'strMeal': instance.name,
      'strMealThumb': instance.thumbnail,
      'strCategory': instance.category,
      'strInstructions': instance.instructions,
      'ingredients': instance.ingredients,
    };
