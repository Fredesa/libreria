import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libreria/src/UI/pages/home_page.dart';
import 'package:libreria/src/domain/models/book_model.dart';
import 'package:libreria/src/infrastructure/book_api.dart';
import 'package:libreria/src/infrastructure/book_api_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'home_page_test.mocks.dart';

@GenerateMocks([BookApi])
void main() {
  late MockBookApi mockBookApi;

  setUp(() {
    mockBookApi = MockBookApi();
  });

  group('HomePageState', () {
    testWidgets('loads books on initState', (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        // Arrange
        when(mockBookApi.newBooks()).thenAnswer((_) async => [
              BookModel(
                title: 'Test Book',
                subtitle: 'Subtitle',
                isbn13: '1234567890123',
                price: '\$10',
                image: 'https://via.placeholder.com/150',
                url: 'https://example.com',
              ),
            ]);

        // Act
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              bookApiProvider.overrideWithValue(mockBookApi),
            ],
            child: const MaterialApp(home: HomePage()),
          ),
        );

        // Allow async tasks to complete
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Catalogo de Libros'), findsOneWidget);
        expect(find.text('Test Book'), findsOneWidget);
        expect(find.byType(Image), findsWidgets);
      });
    });

    testWidgets('shows alert dialog when no books found', (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        // Arrange
        when(mockBookApi.newBooks()).thenAnswer((_) async => [
              BookModel(
                title: 'Test Book',
                subtitle: 'Subtitle',
                isbn13: '1234567890123',
                price: '\$10',
                image: 'https://via.placeholder.com/150',
                url: 'https://example.com',
              ),
            ]);
        when(mockBookApi.searchBooks('NonExistentBook')).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              bookApiProvider.overrideWithValue(mockBookApi),
            ],
            child: const MaterialApp(home: HomePage()),
          ),
        );

        await tester.enterText(find.byType(TextField), 'NonExistentBook');
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('No se encontraron resultados'), findsOneWidget);
      });
    });
  });
}