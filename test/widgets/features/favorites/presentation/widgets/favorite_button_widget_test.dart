import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:recipe_book/features/favorites/presentation/widgets/favorite_button_widget.dart';

import 'favorite_button_widget_test.mocks.dart';

@GenerateMocks([FavoriteBloc])
void main() {
  group('FavoriteButtonWidget', () {
    late MockFavoriteBloc mockFavoriteBloc;

    setUp(() {
      mockFavoriteBloc = MockFavoriteBloc();
      when(mockFavoriteBloc.state).thenReturn(const FavoriteState.initial());
      when(mockFavoriteBloc.stream).thenAnswer((_) => Stream.value(const FavoriteState.initial()));
      when(mockFavoriteBloc.add(any)).thenReturn(null);
    });

    Widget createTestWidget({
      required String mealId,
      required bool isFavorite,
      void Function(String)? onFavoriteToggled,
      double? size,
    }) {
      return MaterialApp(
        home: BlocProvider<FavoriteBloc>.value(
          value: mockFavoriteBloc,
          child: Scaffold(
            body: FavoriteButtonWidget(
              mealId: mealId,
              isFavorite: isFavorite,
              onFavoriteToggled: onFavoriteToggled,
              size: size ?? 24.0,
            ),
          ),
        ),
      );
    }

    group('UI Display', () {
      testWidgets('should display favorite icon when isFavorite is true', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            mealId: 'test-meal-id',
            isFavorite: true,
          ),
        );

        expect(find.byIcon(Icons.favorite), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border), findsNothing);

        final favoriteIcon = tester.widget<Icon>(find.byIcon(Icons.favorite));
        expect(favoriteIcon.color, equals(Colors.red));
      });

      testWidgets('should display favorite border icon when isFavorite is false', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            mealId: 'test-meal-id',
            isFavorite: false,
          ),
        );

        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsNothing);

        final favoriteBorderIcon = tester.widget<Icon>(find.byIcon(Icons.favorite_border));
        expect(favoriteBorderIcon.color, equals(Colors.grey));
      });

      testWidgets('should display correct icon size when specified', (tester) async {
        const customSize = 32.0;

        await tester.pumpWidget(
          createTestWidget(
            mealId: 'test-meal-id',
            isFavorite: true,
            size: customSize,
          ),
        );

        final favoriteIcon = tester.widget<Icon>(find.byIcon(Icons.favorite));
        expect(favoriteIcon.size, equals(customSize));
      });

      testWidgets('should display default size when not specified', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            mealId: 'test-meal-id',
            isFavorite: true,
          ),
        );

        final favoriteIcon = tester.widget<Icon>(find.byIcon(Icons.favorite));
        expect(favoriteIcon.size, equals(24.0));
      });

      testWidgets('should display container with correct styling', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            mealId: 'test-meal-id',
            isFavorite: true,
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration! as BoxDecoration;

        expect(decoration.shape, equals(BoxShape.circle));
        expect(decoration.color, equals(Colors.white.withValues(alpha: 0.9)));
        expect(decoration.boxShadow, isNotNull);
        expect(decoration.boxShadow!.length, equals(1));
      });
    });

    group('Interactions', () {
      testWidgets('should call onFavoriteToggled when tapped', (tester) async {
        String? tappedMealId;
        const testMealId = 'test-meal-id';

        await tester.pumpWidget(
          createTestWidget(
            mealId: testMealId,
            isFavorite: false,
            onFavoriteToggled: (mealId) {
              tappedMealId = mealId;
            },
          ),
        );

        await tester.tap(find.byType(GestureDetector));
        await tester.pump();

        expect(tappedMealId, equals(testMealId));
      });

      testWidgets('should add FavoriteToggled event to bloc when tapped', (tester) async {
        const testMealId = 'test-meal-id';

        await tester.pumpWidget(
          createTestWidget(
            mealId: testMealId,
            isFavorite: false,
          ),
        );

        await tester.tap(find.byType(GestureDetector));
        await tester.pump();

        verify(mockFavoriteBloc.add(const FavoriteToggled(testMealId))).called(1);
      });

      testWidgets('should work without onFavoriteToggled callback', (tester) async {
        const testMealId = 'test-meal-id';

        await tester.pumpWidget(
          createTestWidget(
            mealId: testMealId,
            isFavorite: false,
          ),
        );

        await tester.tap(find.byType(GestureDetector));
        await tester.pump();

        verify(mockFavoriteBloc.add(const FavoriteToggled(testMealId))).called(1);
      });

      testWidgets('should handle multiple taps correctly', (tester) async {
        const testMealId = 'test-meal-id';
        var tapCount = 0;

        await tester.pumpWidget(
          createTestWidget(
            mealId: testMealId,
            isFavorite: false,
            onFavoriteToggled: (mealId) {
              tapCount++;
            },
          ),
        );

        await tester.tap(find.byType(GestureDetector));
        await tester.pump();
        await tester.tap(find.byType(GestureDetector));
        await tester.pump();

        expect(tapCount, equals(2));
        verify(mockFavoriteBloc.add(const FavoriteToggled(testMealId))).called(2);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty mealId', (tester) async {
        const emptyMealId = '';

        await tester.pumpWidget(
          createTestWidget(
            mealId: emptyMealId,
            isFavorite: false,
          ),
        );

        await tester.tap(find.byType(GestureDetector));
        await tester.pump();

        verify(mockFavoriteBloc.add(const FavoriteToggled(emptyMealId))).called(1);
      });

      testWidgets('should handle very large size', (tester) async {
        const largeSize = 100.0;

        await tester.pumpWidget(
          createTestWidget(
            mealId: 'test-meal-id',
            isFavorite: true,
            size: largeSize,
          ),
        );

        final favoriteIcon = tester.widget<Icon>(find.byIcon(Icons.favorite));
        expect(favoriteIcon.size, equals(largeSize));
      });

      testWidgets('should handle very small size', (tester) async {
        const smallSize = 8.0;

        await tester.pumpWidget(
          createTestWidget(
            mealId: 'test-meal-id',
            isFavorite: true,
            size: smallSize,
          ),
        );

        final favoriteIcon = tester.widget<Icon>(find.byIcon(Icons.favorite));
        expect(favoriteIcon.size, equals(smallSize));
      });
    });
  });
}
