import 'package:equatable/equatable.dart';

class FavoriteMeal extends Equatable {
  const FavoriteMeal({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.category,
    required this.instructions,
    required this.ingredients,
    required this.addedAt,
  });

  const FavoriteMeal.empty()
    : id = '',
      name = '',
      thumbnail = null,
      category = '',
      instructions = '',
      ingredients = const {},
      addedAt = null;

  final String id;
  final String name;
  final String? thumbnail;
  final String category;
  final String instructions;
  final Map<String, String> ingredients;
  final DateTime? addedAt;

  FavoriteMeal copyWith({
    String? id,
    String? name,
    String? thumbnail,
    String? category,
    String? instructions,
    Map<String, String>? ingredients,
    DateTime? addedAt,
  }) {
    return FavoriteMeal(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      category: category ?? this.category,
      instructions: instructions ?? this.instructions,
      ingredients: ingredients ?? this.ingredients,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    thumbnail,
    category,
    instructions,
    ingredients,
    addedAt,
  ];
}
