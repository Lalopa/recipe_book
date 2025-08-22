part of 'meal_bloc.dart';

abstract class MealEvent extends Equatable {
  const MealEvent();
  @override
  List<Object?> get props => [];
}

class MealFetched extends MealEvent {
  const MealFetched();
}

class MealRefreshed extends MealEvent {
  const MealRefreshed();
}

class MealSearched extends MealEvent {
  const MealSearched(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class MealSearchCleared extends MealEvent {
  const MealSearchCleared();
}
