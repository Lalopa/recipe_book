part of 'meal_bloc.dart';

enum MealStatus { initial, loading, success, failure }

class MealState extends Equatable {
  const MealState({
    required this.status,
    required this.meals,
    required this.letterIndex,
    required this.offsetInLetter,
    required this.hasReachedMax,
  });

  const MealState.initial()
    : status = MealStatus.initial,
      meals = const [],
      letterIndex = 0,
      offsetInLetter = 0,
      hasReachedMax = false;

  final MealStatus status;
  final List<Meal> meals;
  final int letterIndex;
  final int offsetInLetter;
  final bool hasReachedMax;

  MealState copyWith({
    MealStatus? status,
    List<Meal>? meals,
    int? letterIndex,
    int? offsetInLetter,
    bool? hasReachedMax,
  }) {
    return MealState(
      status: status ?? this.status,
      meals: meals ?? this.meals,
      letterIndex: letterIndex ?? this.letterIndex,
      offsetInLetter: offsetInLetter ?? this.offsetInLetter,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status,
    meals,
    letterIndex,
    offsetInLetter,
    hasReachedMax,
  ];
}
