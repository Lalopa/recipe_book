// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart'
    as _i304;
import 'package:recipe_book/core/di/injector.dart' as _i766;
import 'package:recipe_book/features/favorites/data/datasources/favorite_local_datasource.dart'
    as _i466;
import 'package:recipe_book/features/favorites/data/repositories_impl/favorite_repository_impl.dart'
    as _i428;
import 'package:recipe_book/features/favorites/domain/repositories/favorite_repository.dart'
    as _i852;
import 'package:recipe_book/features/favorites/domain/usecases/check_favorite_status.dart'
    as _i692;
import 'package:recipe_book/features/favorites/domain/usecases/get_favorite_meals.dart'
    as _i698;
import 'package:recipe_book/features/favorites/domain/usecases/toggle_favorite.dart'
    as _i180;
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart'
    as _i588;
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart'
    as _i622;
import 'package:recipe_book/features/meals/data/datasources/meal_local_datasource.dart'
    as _i319;
import 'package:recipe_book/features/meals/data/datasources/meal_remote_datasource.dart'
    as _i795;
import 'package:recipe_book/features/meals/data/datasources/meal_rest_provider.dart'
    as _i66;
import 'package:recipe_book/features/meals/data/repositories_imp/meal_repository_impl.dart'
    as _i398;
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart'
    as _i902;
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart'
    as _i211;
import 'package:recipe_book/features/meals/domain/usecases/search_meals.dart'
    as _i81;
import 'package:recipe_book/features/search/presentation/bloc/search_bloc.dart'
    as _i210;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i622.MainCubit>(() => _i622.MainCubit());
    gh.lazySingleton<_i361.Dio>(() => appModule.dio);
    gh.factory<_i466.FavoriteLocalDataSource>(
      () =>
          _i466.FavoriteLocalDataSourceImpl(gh<_i304.ObjectBoxCacheManager>()),
    );
    gh.factory<_i319.MealLocalDataSource>(
      () => _i319.MealLocalDataSourceImpl(gh<_i304.ObjectBoxCacheManager>()),
    );
    gh.factory<_i795.MealRemoteDataSource>(
      () => _i66.MealRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i902.MealRepository>(
      () => _i398.MealRepositoryImpl(
        gh<_i795.MealRemoteDataSource>(),
        gh<_i319.MealLocalDataSource>(),
      ),
    );
    gh.factory<_i852.FavoriteRepository>(
      () => _i428.FavoriteRepositoryImpl(gh<_i466.FavoriteLocalDataSource>()),
    );
    gh.factory<_i698.GetFavoriteMeals>(
      () => _i698.GetFavoriteMeals(gh<_i852.FavoriteRepository>()),
    );
    gh.factory<_i180.ToggleFavorite>(
      () => _i180.ToggleFavorite(gh<_i852.FavoriteRepository>()),
    );
    gh.factory<_i692.CheckFavoriteStatus>(
      () => _i692.CheckFavoriteStatus(gh<_i852.FavoriteRepository>()),
    );
    gh.factory<_i211.GetMealsByLetter>(
      () => _i211.GetMealsByLetter(gh<_i902.MealRepository>()),
    );
    gh.factory<_i81.SearchMeals>(
      () => _i81.SearchMeals(gh<_i902.MealRepository>()),
    );
    gh.factory<_i588.FavoriteBloc>(
      () => _i588.FavoriteBloc(
        gh<_i698.GetFavoriteMeals>(),
        gh<_i180.ToggleFavorite>(),
        gh<_i692.CheckFavoriteStatus>(),
      ),
    );
    gh.factory<_i210.SearchBloc>(
      () => _i210.SearchBloc(gh<_i81.SearchMeals>()),
    );
    return this;
  }
}

class _$AppModule extends _i766.AppModule {}
