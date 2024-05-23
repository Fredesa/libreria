import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:libreria/src/domain/models/book_model.dart';
import 'package:libreria/src/infrastructure/book_api.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'book_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient client;
  late BookApi bookApi;

  setUp(() {
    client = MockClient();
    bookApi = BookApi(client: client);
  });

  group('BookApi Tests', () {
    test('searchBooks funciona correctamente', () async {
      final response = {
        'total': '1',
        'page': '1',
        'books': [
          {
            'title': 'Flutter for Beginners',
            'subtitle': 'An introduction to Flutter',
            'isbn13': '9781234567890',
            'price': '\$29.99',
            'image': 'https://dummyimage.com/200x300/000/fff&text=Book',
            'url': 'https://dummyurl.com/flutter-for-beginners'
          }
        ]
      };

      when(client.get(Uri.parse('https://api.itbook.store/1.0/search/Flutter')))
          .thenAnswer((_) async => http.Response(json.encode(response), 200));

      final books = await bookApi.searchBooks('Flutter');

      expect(books, isA<List<BookModel>>());
      expect(books.length, 1);
      expect(books[0].title, 'Flutter for Beginners');
    });

    test('newBooks funciona satisfactoriamente', () async {
      final response = {
        'total': '1',
        'books': [
          {
            'title': 'Dart Programming',
            'subtitle': 'Learn Dart for beginners',
            'isbn13': '9780987654321',
            'price': '\$19.99',
            'image': 'https://dummyimage.com/200x300/000/fff&text=Dart',
            'url': 'https://dummyurl.com/dart-programming'
          }
        ]
      };

      when(client.get(Uri.parse('https://api.itbook.store/1.0/new')))
          .thenAnswer((_) async => http.Response(json.encode(response), 200));

      final books = await bookApi.newBooks();

      expect(books, isA<List<BookModel>>());
      expect(books.length, 1);
      expect(books[0].title, 'Dart Programming');
    });

    test('getMoreInfo retorna información detallada de un libro correctamente',
        () async {
      final response = {
        'title': 'Advanced Flutter',
        'subtitle': 'A detailed guide to Flutter development',
        'isbn13': '9789876543210',
        'price': '\$39.99',
        'image': 'https://dummyimage.com/200x300/000/fff&text=Advanced+Flutter',
        'url': 'https://dummyurl.com/advanced-flutter',
        'authors': 'John Doe',
        'publisher': 'Tech Publishing',
        'pages': '320',
        'year': '2023',
        'rating': '5',
        'desc':
            'A comprehensive guide to Flutter development for advanced programmers.'
      };

      when(client.get(
              Uri.parse('https://api.itbook.store/1.0/books/9789876543210')))
          .thenAnswer((_) async => http.Response(json.encode(response), 200));

      final book = await bookApi.getMoreInfo('9789876543210');

      expect(book, isA<BookModel>());
      expect(book.title, 'Advanced Flutter');
      expect(book.authors, 'John Doe');
    });

    test('searchBooks tira una excepcion si falla el llamado', () async {
      when(client.get(Uri.parse('https://api.itbook.store/1.0/search/Invalid')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => bookApi.searchBooks('Invalid'), throwsException);
    });

    test('newBooks bota una excepcion si falla el llamado', () async {
      when(client.get(Uri.parse('https://api.itbook.store/1.0/new')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => bookApi.newBooks(), throwsException);
    });

    test('newBooks bota una excepcion si falla el llamado', () async {
      when(client.get(Uri.parse('https://api.itbook.store/1.0/books/9789876543210')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => bookApi.getMoreInfo('9789876543210'), throwsException);
    });
  });
}
