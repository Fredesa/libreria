
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libreria/src/domain/models/book_model.dart';

class BookstoreNotifier extends StateNotifier<List<BookModel>> {
  BookstoreNotifier() : super([]);

  void add(BookModel book) {
    state = [...state, book];
  }

  void addAll(List<BookModel> books) {
    state = [...state, ...books];
  }

  void updateOne(BookModel book) {
    final i = state.indexWhere((e) => e.isbn13 == book.isbn13);
    state = [...state.sublist(0, i), book, ...state.sublist(i + 1)];
  }

  void resetState() {
    state = [];
  }
}

final booksProvider = StateNotifierProvider<BookstoreNotifier, List<BookModel>>(
  (ref) => BookstoreNotifier(),
);

final filteredBooksProvider = Provider((ref) {
  return ref.watch(booksProvider);
});
