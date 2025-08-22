import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart';

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  MealBloc(
    this._getMealsByLetter,
  ) : super(
        const MealState.initial(),
      ) {
    on<MealFetched>(_onFetched);
    on<MealRefreshed>(_onRefreshed);
  }

  final GetMealsByLetter _getMealsByLetter;

  static const _letters = 'abcdefghijklmnopqrstuvwxyz';
  static const int _pageSize = 12;

  final Map<String, List<Meal>> _cacheByLetter = {};

  Future<void> _onRefreshed(
    MealRefreshed event,
    Emitter<MealState> emit,
  ) async {
    _cacheByLetter.clear();
    emit(const MealState.initial());
    add(const MealFetched());
  }

  Future<void> _onFetched(MealFetched event, Emitter<MealState> emit) async {
    if (state.hasReachedMax || state.status == MealStatus.loading) return;

    emit(state.copyWith(status: MealStatus.loading));

    try {
      var letterIndex = state.letterIndex;
      var offsetInLetter = state.offsetInLetter;
      final aggregated = List<Meal>.of(state.meals);

      while (aggregated.length - state.meals.length < _pageSize && letterIndex < _letters.length) {
        final letter = _letters[letterIndex];

        final items = await _getMealsForLetter(letter);

        if (items.isEmpty) {
          letterIndex++;
          offsetInLetter = 0;
          continue;
        }

        final remainingInLetter = items.length - offsetInLetter;
        final need = _pageSize - (aggregated.length - state.meals.length);
        final take = remainingInLetter > need ? need : remainingInLetter;

        if (take > 0) {
          aggregated.addAll(items.sublist(offsetInLetter, offsetInLetter + take));
          offsetInLetter += take;
        }

        if (offsetInLetter >= items.length) {
          letterIndex++;
          offsetInLetter = 0;
        }
      }

      final reachedMax = letterIndex >= _letters.length && (state.meals.length == aggregated.length);

      emit(
        state.copyWith(
          status: MealStatus.success,
          meals: aggregated,
          letterIndex: letterIndex,
          offsetInLetter: offsetInLetter,
          hasReachedMax: reachedMax,
        ),
      );
    } on Exception catch (_) {
      emit(
        state.copyWith(
          status: MealStatus.failure,
        ),
      );
    }
  }

  Future<List<Meal>> _getMealsForLetter(String letter) async {
    if (_cacheByLetter.containsKey(letter)) return _cacheByLetter[letter]!;
    final meals = await _getMealsByLetter(letter);
    _cacheByLetter[letter] = meals;
    return meals;
  }
}
