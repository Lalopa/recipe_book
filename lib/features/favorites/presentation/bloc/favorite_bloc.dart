import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:recipe_book/features/favorites/domain/usecases/check_favorite_status.dart';
import 'package:recipe_book/features/favorites/domain/usecases/get_favorite_meals.dart';
import 'package:recipe_book/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

@injectable
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc(
    this._getFavoriteMeals,
    this._toggleFavorite,
    this._checkFavoriteStatus,
  ) : super(
        const FavoriteState.initial(),
      ) {
    on<FavoritesLoaded>(_onFavoritesLoaded);
    on<FavoriteToggled>(_onFavoriteToggled);
    on<FavoriteStatusChecked>(_onFavoriteStatusChecked);
  }

  final GetFavoriteMeals _getFavoriteMeals;
  final ToggleFavorite _toggleFavorite;
  final CheckFavoriteStatus _checkFavoriteStatus;

  Future<void> _onFavoritesLoaded(
    FavoritesLoaded event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FavoriteStatus.loading, isLoading: true));
      final favoriteMeals = await _getFavoriteMeals();

      // Crear un nuevo mapa de estados de favoritos
      final newFavoriteStatuses = <String, bool>{};

      // Marcar todas las comidas favoritas como true
      for (final meal in favoriteMeals) {
        newFavoriteStatuses[meal.id] = true;
      }

      // Mantener el estado de las comidas que no están en la lista de favoritos
      // pero que ya tenían un estado previo
      for (final entry in state.favoriteStatuses.entries) {
        if (!newFavoriteStatuses.containsKey(entry.key)) {
          newFavoriteStatuses[entry.key] = false;
        }
      }

      emit(
        state.copyWith(
          status: FavoriteStatus.success,
          favoriteMeals: favoriteMeals,
          isLoading: false,
          favoriteStatuses: newFavoriteStatuses,
        ),
      );
    } on Exception catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure, isLoading: false));
    }
  }

  Future<void> _onFavoriteToggled(
    FavoriteToggled event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      await _toggleFavorite(event.mealId);

      final newFavoriteStatus = await _checkFavoriteStatus(event.mealId);

      emit(
        state.copyWith(
          favoriteStatuses: {
            ...state.favoriteStatuses,
            event.mealId: newFavoriteStatus,
          },
        ),
      );

      add(const FavoritesLoaded());
    } on Exception catch (_) {}
  }

  Future<void> _onFavoriteStatusChecked(
    FavoriteStatusChecked event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      final isFavorite = await _checkFavoriteStatus(event.mealId);
      emit(
        state.copyWith(
          status: FavoriteStatus.success,
          favoriteStatuses: {
            ...state.favoriteStatuses,
            event.mealId: isFavorite,
          },
        ),
      );
    } on Exception catch (_) {
      // Manejar error si es necesario
    }
  }
}
