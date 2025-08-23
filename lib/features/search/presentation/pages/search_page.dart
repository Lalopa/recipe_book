import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_book/core/di/injector.dart';
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:recipe_book/features/meals/presentation/widgets/custom_app_bar_widget.dart';
import 'package:recipe_book/features/search/presentation/bloc/search_bloc.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_error_widget.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_initial_widget.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_loading_widget.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_results_widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchBloc>(),
      child: const SearchView(),
    );
  }
}

// Constructor alternativo para testing
class SearchPageTestable extends StatelessWidget {
  const SearchPageTestable({
    required this.searchBloc,
    required this.favoriteBloc,
    super.key,
  });
  final SearchBloc searchBloc;
  final FavoriteBloc favoriteBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: searchBloc),
        BlocProvider.value(value: favoriteBloc),
      ],
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final TextEditingController _searchController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Cargar el estado de favoritos al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteBloc>().add(const FavoritesLoaded());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchBloc>().add(SearchQueryChanged(query));
    });
  }

  void _onClearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(const SearchCleared());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, child) {
                return TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Ex: chicken, pasta, salad',
                    prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass),
                    suffixIcon: value.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _onClearSearch,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  autofocus: true,
                  onChanged: _onSearchChanged,
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                switch (state.status) {
                  case SearchStatus.initial:
                    return const SearchInitialWidget();
                  case SearchStatus.loading:
                    return const SearchLoadingWidget();
                  case SearchStatus.success:
                    return SearchResultsWidget(
                      meals: state.meals,
                      query: state.query,
                    );
                  case SearchStatus.failure:
                    return SearchErrorWidget(
                      errorMessage: state.errorMessage ?? 'Unknown error',
                      onRetry: () {
                        if (state.query.isNotEmpty) {
                          context.read<SearchBloc>().add(
                            SearchQueryChanged(state.query),
                          );
                        }
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
