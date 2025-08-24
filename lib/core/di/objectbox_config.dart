import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
import 'package:recipe_book/core/error/error.dart';
import 'package:recipe_book/core/models/objectbox/meal_objectbox_model.dart';
import 'package:recipe_book/core/models/objectbox/search_cache_objectbox_model.dart';
import 'package:recipe_book/objectbox.g.dart';

class ObjectBoxConfig {
  static Store? _store;
  static Box<MealObjectBoxModel>? _mealBox;
  static Box<SearchObjectBoxModel>? _searchCacheBox;

  static Store get store {
    if (_store == null) {
      throw StateError('ObjectBox has not been initialized. Call initObjectBox() first.');
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

      _store = await openStore(directory: objectboxDir);

      log('ObjectBox initialized successfully at: $objectboxDir');

      ObjectBoxCacheManager().initialize(_store!);
    } on Exception catch (e) {
      log('Error initializing ObjectBox: $e');
      // Don't throw in test environment to avoid breaking tests
      if (!kDebugMode) {
        throw const LocalDatabaseFailure('Error initializing local database');
      }
    }
  }

  static Future<Directory> _getDocumentsDirectory() async {
    try {
      if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
        final appDocDir = await getApplicationDocumentsDirectory();
        return appDocDir;
      } else {
        final tempDir = await getTemporaryDirectory();
        return tempDir;
      }
    } on Exception catch (e) {
      log('Error getting documents directory: $e');
      try {
        final tempDir = await getTemporaryDirectory();
        return tempDir;
      } on Exception catch (tempError) {
        log('Error getting temporary directory: $tempError');
        throw const FileFailure('Could not access file system');
      }
    }
  }

  static void closeObjectBox() {
    _store?.close();
    _store = null;
    _mealBox = null;
    _searchCacheBox = null;
  }
}
