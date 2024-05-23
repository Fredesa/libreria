import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libreria/src/infrastructure/book_api.dart';
import 'package:http/http.dart' as http;

final bookApiProvider = Provider<BookApi>((ref) {
  return BookApi(client: http.Client());
});