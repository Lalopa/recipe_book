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
