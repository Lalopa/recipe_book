import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
import 'package:recipe_book/core/di/injection.config.dart';
import 'package:recipe_book/core/di/objectbox_config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

Future<void> initializeObjectBox() async {
  await ObjectBoxConfig.initObjectBox();

  final cacheManager = ObjectBoxCacheManager()..initialize(ObjectBoxConfig.store);

  getIt.registerSingleton<ObjectBoxCacheManager>(cacheManager);
}
