part of 'favorite_bloc.dart';

enum FavoriteStatus { initial, loading, success, failure }

class FavoriteState extends Equatable {
  const FavoriteState({
    required this.status,
    required this.favoriteMeals,
    required this.isLoading,
    required this.favoriteStatuses,
  });

  const FavoriteState.initial()
    : status = FavoriteStatus.initial,
      favoriteMeals = const [],
      isLoading = false,
      favoriteStatuses = const {};

  final FavoriteStatus status;
  final List<Meal> favoriteMeals;
  final bool isLoading;
  final Map<String, bool> favoriteStatuses;

  FavoriteState copyWith({
    FavoriteStatus? status,
    List<Meal>? favoriteMeals,
    bool? isLoading,
    Map<String, bool>? favoriteStatuses,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      favoriteMeals: favoriteMeals ?? this.favoriteMeals,
      isLoading: isLoading ?? this.isLoading,
      favoriteStatuses: favoriteStatuses ?? this.favoriteStatuses,
    );
  }

  @override
  List<Object?> get props => [
    status,
    favoriteMeals,
    isLoading,
    favoriteStatuses,
  ];
}
