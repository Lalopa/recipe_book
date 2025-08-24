part of 'meal_bloc.dart';

enum MealStatus { initial, loading, success, failure }

@freezed
class MealState with _$MealState {
  const factory MealState({
    required MealStatus status,
    required List<Meal> meals,
    required int letterIndex,
    required int offsetInLetter,
    required bool hasReachedMax,
  }) = _MealState;

  const factory MealState.initial({
    @Default(MealStatus.initial) MealStatus status,
    @Default([]) List<Meal> meals,
    @Default(0) int letterIndex,
    @Default(0) int offsetInLetter,
    @Default(false) bool hasReachedMax,
  }) = _Initial;
}
