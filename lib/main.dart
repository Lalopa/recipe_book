import 'package:flutter/material.dart';
import 'package:recipe_book/core/di/injector.dart';
import 'package:recipe_book/core/routes/app_router.dart';
import 'package:recipe_book/core/theme/theme.dart';
import 'package:recipe_book/core/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Book',
      theme: AppTheme.lightTheme(),
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutesNames.home,
    );
  }
}
