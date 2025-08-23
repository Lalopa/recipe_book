import 'package:objectbox/objectbox.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

@Entity()
class MealObjectBoxModel {
  MealObjectBoxModel({
    required this.mealId,
    required this.name,
    required this.category,
    required this.instructions,
    required this.ingredientsJson,
    required this.timestamp,
    this.id = 0,
    this.thumbnail,
    this.expiresAt,
    this.isFavorite = false,
  });

  factory MealObjectBoxModel.fromMealModel(MealModel meal, {Duration? ttl}) {
    final now = DateTime.now();
    final expiresAt = ttl != null ? now.add(ttl) : null;

    return MealObjectBoxModel(
      mealId: meal.id,
      name: meal.name,
      thumbnail: meal.thumbnail,
      category: meal.category,
      instructions: meal.instructions,
      ingredientsJson: mapToJson(meal.ingredients),
      timestamp: now,
      expiresAt: expiresAt,
      // Por defecto no es favorito al crear desde MealModel
    );
  }

  @Id()
  int id;

  @Unique()
  String mealId;

  String name;
  String? thumbnail;
  String category;
  String instructions;

  @Property(type: PropertyType.date)
  DateTime timestamp;

  @Property(type: PropertyType.date)
  DateTime? expiresAt;

  // Campo para favoritos
  bool isFavorite;

  // Campos para ingredientes (serializados como JSON)
  String ingredientsJson;

  MealModel toMealModel() {
    return MealModel(
      id: mealId,
      name: name,
      thumbnail: thumbnail,
      category: category,
      instructions: instructions,
      ingredients: jsonToMap(ingredientsJson),
      // No incluimos isFavorite ya que MealModel no lo tiene
    );
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  static String mapToJson(Map<String, String> ingredients) {
    final entries = ingredients.entries.map((e) => '"${e.key}":"${e.value}"').join(',');
    return '{$entries}';
  }

  static Map<String, String> jsonToMap(String json) {
    try {
      final map = <String, String>{};
      if (json.isEmpty || json == '{}') return map;

      final content = json.substring(1, json.length - 1);
      if (content.isEmpty) return map;

      final pairs = content.split(',');
      for (final pair in pairs) {
        final colonIndex = pair.indexOf(':');
        if (colonIndex > 0) {
          final key = pair.substring(0, colonIndex).trim().replaceAll('"', '');
          final value = pair.substring(colonIndex + 1).trim().replaceAll('"', '');
          map[key] = value;
        }
      }
      return map;
    } on Exception catch (_) {
      return <String, String>{};
    }
  }
}
