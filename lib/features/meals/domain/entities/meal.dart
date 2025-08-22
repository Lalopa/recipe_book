import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  const Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.category,
    required this.instructions,
    required this.ingredients,
    this.isFavorite = false,
  });
  const Meal.empty()
    : id = '',
      name = '',
      thumbnail = null,
      category = '',
      instructions = '',
      ingredients = const {},
      isFavorite = false;

  final String id;
  final String name;
  final String? thumbnail;
  final String category;
  final String instructions;
  final Map<String, String> ingredients;
  final bool isFavorite;

  @override
  List<Object?> get props => [
    id,
    name,
    thumbnail,
    category,
    instructions,
    ingredients,
    isFavorite,
  ];
}
