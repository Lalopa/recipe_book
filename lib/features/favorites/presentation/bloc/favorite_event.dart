part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object?> get props => [];
}

class FavoritesLoaded extends FavoriteEvent {
  const FavoritesLoaded();
}

class FavoriteToggled extends FavoriteEvent {
  const FavoriteToggled(this.mealId);

  final String mealId;

  @override
  List<Object?> get props => [mealId];
}

class FavoriteStatusChecked extends FavoriteEvent {
  const FavoriteStatusChecked(this.mealId);

  final String mealId;

  @override
  List<Object?> get props => [mealId];
}
