// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_meal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoriteMealModelImpl _$$FavoriteMealModelImplFromJson(
  Map<String, dynamic> json,
) => _$FavoriteMealModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  thumbnail: json['thumbnail'] as String?,
  category: json['category'] as String,
  instructions: json['instructions'] as String,
  ingredients: Map<String, String>.from(json['ingredients'] as Map),
  addedAt: json['addedAt'] == null
      ? null
      : DateTime.parse(json['addedAt'] as String),
);

Map<String, dynamic> _$$FavoriteMealModelImplToJson(
  _$FavoriteMealModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'thumbnail': instance.thumbnail,
  'category': instance.category,
  'instructions': instance.instructions,
  'ingredients': instance.ingredients,
  'addedAt': instance.addedAt?.toIso8601String(),
};
