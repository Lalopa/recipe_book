part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.meals = const [],
    this.query = '',
    this.errorMessage,
  });

  const SearchState.initial({
    this.status = SearchStatus.initial,
    this.meals = const [],
    this.query = '',
    this.errorMessage,
  });

  final SearchStatus status;
  final List<Meal> meals;
  final String query;
  final String? errorMessage;

  SearchState copyWith({
    SearchStatus? status,
    List<Meal>? meals,
    String? query,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      meals: meals ?? this.meals,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    meals,
    query,
    errorMessage,
  ];
}
