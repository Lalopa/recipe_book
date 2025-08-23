import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
import 'package:recipe_book/core/models/objectbox/meal_objectbox_model.dart';
import 'package:recipe_book/core/models/objectbox/search_cache_objectbox_model.dart';
import 'package:recipe_book/objectbox.g.dart';

class ObjectBoxConfig {
  static Store? _store;
  static Box<MealObjectBoxModel>? _mealBox;
  static Box<SearchObjectBoxModel>? _searchCacheBox;

  static Store get store {
    if (_store == null) {
      throw StateError('ObjectBox no ha sido inicializado. Llama a initObjectBox() primero.');
    }
    return _store!;
  }

  static Box<MealObjectBoxModel> get mealBox {
    _mealBox ??= store.box<MealObjectBoxModel>();
    return _mealBox!;
  }

  static Box<SearchObjectBoxModel> get searchCacheBox {
    _searchCacheBox ??= store.box<SearchObjectBoxModel>();
    return _searchCacheBox!;
  }

  static Future<void> initObjectBox() async {
    if (_store != null) return;

    try {
      final docsDir = await _getDocumentsDirectory();
      final objectboxDir = path.join(docsDir.path, 'objectbox');

      // Crear el store usando el modelo generado
      _store = await openStore(directory: objectboxDir);

      log('ObjectBox initialized successfully at: $objectboxDir');

      // Inicializar el cache manager completo
      ObjectBoxCacheManager.instance.initialize(_store!);
    } on Exception catch (e) {
      log('Error initializing ObjectBox: $e');
    }
  }

  static Future<Directory> _getDocumentsDirectory() async {
    try {
      if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
        // Usar el directorio de documentos del usuario
        final appDocDir = await getApplicationDocumentsDirectory();
        return appDocDir;
      } else {
        // Fallback: usar el directorio temporal
        final tempDir = await getTemporaryDirectory();
        return tempDir;
      }
    } on Exception catch (e) {
      log('Error getting documents directory: $e');
      // Fallback: usar directorio temporal
      final tempDir = await getTemporaryDirectory();
      return tempDir;
    }
  }

  static void closeObjectBox() {
    _store?.close();
    _store = null;
    _mealBox = null;
    _searchCacheBox = null;
  }
}
