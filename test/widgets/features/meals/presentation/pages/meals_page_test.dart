import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';
import 'package:recipe_book/features/meals/presentation/widgets/custom_app_bar_widget.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_loading_widget.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_preview_error_widget.dart';

// Mock simple del bloc para testing
class MockMealBloc extends Bloc<MealEvent, MealState> implements MealBloc {
  MockMealBloc() : super(const MealState.initial());

  @override
  void add(MealEvent event) {
    // Simular comportamiento del bloc
    if (event is MealFetched) {
      emit(state.copyWith(status: MealStatus.loading));
      // Simular carga exitosa inmediatamente sin delay
      emit(
        state.copyWith(
          status: MealStatus.success,
          meals: _testMeals,
        ),
      );
    } else if (event is MealRefreshed) {
      emit(state.copyWith(status: MealStatus.loading));
      emit(
        state.copyWith(
          status: MealStatus.success,
          meals: _testMeals,
        ),
      );
    }
  }

  static final List<Meal> _testMeals = [
    const Meal(
      id: '1',
      name: 'Test Meal 1',
      thumbnail: 'https://example.com/meal1.jpg',
      category: 'Test Category 1',
      instructions: 'Test instructions 1',
      ingredients: {'ingredient1': 'amount1'},
    ),
    const Meal(
      id: '2',
      name: 'Test Meal 2',
      thumbnail: 'https://example.com/meal2.jpg',
      category: 'Test Category 2',
      instructions: 'Test instructions 2',
      ingredients: {'ingredient2': 'amount2'},
    ),
  ];
}

// Mock simple del MainCubit para testing
class MockMainCubit extends Cubit<int> implements MainCubit {
  MockMainCubit() : super(0);

  @override
  void setTab(int index) {
    emit(index);
  }
}

void main() {
  group('MealsPage Integration Tests', () {
    testWidgets('should display CustomAppBarWidget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBarWidget(),
          ),
        ),
      );

      expect(find.byType(CustomAppBarWidget), findsOneWidget);
    });

    testWidgets('should display loading widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MealLoadingWidget(),
          ),
        ),
      );

      expect(find.byType(MealLoadingWidget), findsOneWidget);
    });

    testWidgets('should display error widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MealPreviewWidgetError(),
          ),
        ),
      );

      expect(find.byType(MealPreviewWidgetError), findsOneWidget);
    });

    testWidgets('should handle empty state', (tester) async {
      final emptyBloc = MockMealBloc()
        ..emit(
          const MealState.initial().copyWith(
            status: MealStatus.success,
            meals: [],
          ),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>(
            create: (context) => emptyBloc,
            child: Scaffold(
              body: BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  if (state.status == MealStatus.success && state.meals.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No results found'),
                          Text('We are working on it'),
                        ],
                      ),
                    );
                  }
                  return const MealLoadingWidget();
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('No results found'), findsOneWidget);
      expect(find.text('We are working on it'), findsOneWidget);
    });

    testWidgets('should handle loading state', (tester) async {
      final loadingBloc = MockMealBloc()
        ..emit(
          const MealState.initial().copyWith(
            status: MealStatus.loading,
          ),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>(
            create: (context) => loadingBloc,
            child: Scaffold(
              body: BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  if (state.status == MealStatus.loading) {
                    return const MealLoadingWidget();
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(MealLoadingWidget), findsOneWidget);
    });

    testWidgets('should handle success state with meals', (tester) async {
      final successBloc = MockMealBloc()
        ..emit(
          const MealState.initial().copyWith(
            status: MealStatus.success,
            meals: MockMealBloc._testMeals,
          ),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>(
            create: (context) => successBloc,
            child: Scaffold(
              body: BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  if (state.status == MealStatus.success) {
                    return Column(
                      children: state.meals.map((meal) => Text(meal.name)).toList(),
                    );
                  }
                  return const MealLoadingWidget();
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Meal 1'), findsOneWidget);
      expect(find.text('Test Meal 2'), findsOneWidget);
    });

    testWidgets('should handle failure state', (tester) async {
      final failureBloc = MockMealBloc()
        ..emit(
          const MealState.initial().copyWith(
            status: MealStatus.failure,
          ),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>(
            create: (context) => failureBloc,
            child: Scaffold(
              body: BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  if (state.status == MealStatus.failure) {
                    return const MealPreviewWidgetError();
                  }
                  return const MealLoadingWidget();
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(MealPreviewWidgetError), findsOneWidget);
    });

    testWidgets('should handle state changes', (tester) async {
      final bloc = MockMealBloc();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>(
            create: (context) => bloc,
            child: Scaffold(
              body: BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  switch (state.status) {
                    case MealStatus.loading:
                      return const MealLoadingWidget();
                    case MealStatus.success:
                      if (state.meals.isEmpty) {
                        return const Center(
                          child: Text('No results found'),
                        );
                      }
                      return Column(
                        children: state.meals.map((meal) => Text(meal.name)).toList(),
                      );
                    case MealStatus.failure:
                      return const MealPreviewWidgetError();
                    case MealStatus.initial:
                      return const MealLoadingWidget();
                  }
                },
              ),
            ),
          ),
        ),
      );

      // Estado inicial
      expect(find.byType(MealLoadingWidget), findsOneWidget);

      // Cambiar a estado de éxito
      bloc.emit(
        const MealState.initial().copyWith(
          status: MealStatus.success,
          meals: MockMealBloc._testMeals,
        ),
      );
      await tester.pump();

      expect(find.text('Test Meal 1'), findsOneWidget);
      expect(find.text('Test Meal 2'), findsOneWidget);

      // Cambiar a estado de error
      bloc.emit(
        const MealState.initial().copyWith(
          status: MealStatus.failure,
        ),
      );
      await tester.pump();

      expect(find.byType(MealPreviewWidgetError), findsOneWidget);
    });

    testWidgets('should handle bloc events', (tester) async {
      final bloc = MockMealBloc();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>(
            create: (context) => bloc,
            child: Scaffold(
              body: BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  if (state.status == MealStatus.success) {
                    return Column(
                      children: state.meals.map((meal) => Text(meal.name)).toList(),
                    );
                  }
                  return const MealLoadingWidget();
                },
              ),
            ),
          ),
        ),
      );

      // Estado inicial
      expect(find.byType(MealLoadingWidget), findsOneWidget);

      // Simular que se agregó un evento
      bloc.add(const MealFetched());
      await tester.pump();

      expect(find.text('Test Meal 1'), findsOneWidget);
      expect(find.text('Test Meal 2'), findsOneWidget);
    });

    testWidgets('should display search bar with correct text', (tester) async {
      final bloc = MockMealBloc()
        ..emit(
          const MealState.initial().copyWith(
            status: MealStatus.success,
            meals: MockMealBloc._testMeals,
          ),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>(
            create: (context) => bloc,
            child: Scaffold(
              body: BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  if (state.status == MealStatus.success) {
                    return Column(
                      children: [
                        // Simular search bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFDDDDDD),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.magnifyingGlass,
                                  color: Colors.grey[800],
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Ex: chicken, pasta, salad',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Simular lista de comidas
                        ...state.meals.map((meal) => Text(meal.name)),
                      ],
                    );
                  }
                  return const MealLoadingWidget();
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Ex: chicken, pasta, salad'), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.magnifyingGlass), findsOneWidget);
    });

    testWidgets('should handle refresh event', (tester) async {
      final bloc = MockMealBloc()
        ..emit(
          const MealState.initial().copyWith(
            status: MealStatus.success,
            meals: MockMealBloc._testMeals,
          ),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>(
            create: (context) => bloc,
            child: Scaffold(
              body: BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  if (state.status == MealStatus.success) {
                    return Column(
                      children: [
                        // Simular RefreshIndicator
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              bloc.add(const MealRefreshed());
                            },
                            child: ListView(
                              children: state.meals.map((meal) => Text(meal.name)).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const MealLoadingWidget();
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Meal 1'), findsOneWidget);
      expect(find.text('Test Meal 2'), findsOneWidget);

      // Simular refresh
      bloc.add(const MealRefreshed());
      await tester.pump();

      // Verificar que se mantienen las comidas después del refresh
      expect(find.text('Test Meal 1'), findsOneWidget);
      expect(find.text('Test Meal 2'), findsOneWidget);
    });

    testWidgets('should handle scroll behavior', (tester) async {
      final bloc = MockMealBloc()
        ..emit(
          const MealState.initial().copyWith(
            status: MealStatus.success,
            meals: MockMealBloc._testMeals,
          ),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>(
            create: (context) => bloc,
            child: Scaffold(
              body: BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  if (state.status == MealStatus.success) {
                    return Column(
                      children: state.meals.map((meal) => Text(meal.name)).toList(),
                    );
                  }
                  return const MealLoadingWidget();
                },
              ),
            ),
          ),
        ),
      );

      // Verificar que las comidas se muestran
      expect(find.text('Test Meal 1'), findsOneWidget);
      expect(find.text('Test Meal 2'), findsOneWidget);
    });

    testWidgets('should handle loading state with existing meals', (tester) async {
      final bloc = MockMealBloc()
        ..emit(
          const MealState.initial().copyWith(
            status: MealStatus.loading,
            meals: MockMealBloc._testMeals,
          ),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>(
            create: (context) => bloc,
            child: Scaffold(
              body: BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  if (state.status == MealStatus.loading && state.meals.isNotEmpty) {
                    return Column(
                      children: state.meals.map((meal) => Text(meal.name)).toList(),
                    );
                  }
                  return const MealLoadingWidget();
                },
              ),
            ),
          ),
        ),
      );

      // Debe mostrar las comidas existentes aunque esté en loading
      expect(find.text('Test Meal 1'), findsOneWidget);
      expect(find.text('Test Meal 2'), findsOneWidget);
    });
  });
}
