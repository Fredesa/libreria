import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/models/book_model.dart';

class BookApi {
  final http.Client client;

  BookApi({http.Client? client})
      : client = client ?? http.Client();

  Future<List<BookModel>> searchBooks(String query) async {
    final response = await client.get(Uri.parse('https://api.itbook.store/1.0/search/$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['books'] as List).map((book) => BookModel.fromJson(book)).toList();
    } else {
      throw Exception('No se ha podido cargar los libros');
    }
  }

  Future<List<BookModel>> newBooks() async {
    final response = await client.get(Uri.parse('https://api.itbook.store/1.0/new'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['books'] as List).map((book) => BookModel.fromJson(book)).toList();
    } else {
      throw Exception('No se ha podido cargar los libros');
    }
  }


  Future<BookModel> getMoreInfo(String isbn13) async {
    final response = await client.get(Uri.parse('https://api.itbook.store/1.0/books/$isbn13'));

    if (response.statusCode == 200) {
      return BookModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('No se ha podido obtener mas informacion');
    }
  }
}
