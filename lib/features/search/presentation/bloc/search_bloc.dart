import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/domain/usecases/search_meals.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._searchMeals) : super(const SearchState.initial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchCleared>(_onSearchCleared);
  }

  final SearchMeals _searchMeals;

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(const SearchState.initial());
      return;
    }

    if (query.length < 2) {
      emit(SearchState.initial(query: query));
      return;
    }

    // Clear previous meals when starting a new search
    emit(state.copyWith(status: SearchStatus.loading, query: query, meals: []));

    try {
      final meals = await _searchMeals(query);

      emit(
        state.copyWith(
          status: SearchStatus.success,
          meals: meals,
          query: query,
        ),
      );
    } on Exception catch (error) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: error.toString(),
          query: query,
        ),
      );
    }
  }

  Future<void> _onSearchCleared(
    SearchCleared event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchState.initial());
  }
}
