import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libreria/src/UI/widgets/card_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/book_model.dart';
import '../../infrastructure/book_api_provider.dart';
import '../book_provider.dart';
import '../widgets/card_book.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> searchList = [];
  List<String> searchList2 = [];
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    getHistory();
    _loadBooks();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData();
    final books = ref.watch(filteredBooksProvider);
    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        backgroundColor: Colors.lightGreen[50],
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text('Catalogo de Libros',
              style: TextStyle(color: Colors.black)),
          elevation: 1,
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              if (searchList.isNotEmpty) _buildSearchHistory(),
              books.isEmpty ? showAlertDialog() : _buildBookGrid(books),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SearchBar(
        controller: searchController,
        padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0)),
        hintText: 'Buscar libros',
        onChanged: (value) {
          if (value.isEmpty) {
            _loadBooks();
          }
        },
        onTap: () {
          if (searchController.text.isEmpty) {
            _loadBooks();
          }
        },
        trailing: <Widget>[
          Tooltip(
            message: 'Presiona para buscar',
            child: IconButton(
              onPressed: () {
                _loadSearch(searchController.text);
                if (searchController.text.isNotEmpty) {
                  updateHistory(searchController.text);
                }
              },
              icon: const Icon(Icons.search),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Column(
      children: [
        const Text(
          'Ultimas busquedas',
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: searchList.length,
            itemBuilder: (context, index) {
              if (index < 5) {
                return TextButton(
                  onPressed: () {
                    searchController.text = searchList2[index];
                    _loadSearch(searchController.text);
                  },
                  child: Chip(
                    backgroundColor: Colors.lightGreen[200],
                    label: Text(searchList2[index]),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookGrid(List<BookModel> books) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.64,
          crossAxisCount: 2,
        ),
        itemCount: books.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            key: Key('book_$index'),
            onTap: () async {
              await _fetchMoreInfo(books[index].isbn13).then(
                (_) {
                  final book = ref
                      .watch(booksProvider)
                      .firstWhere((e) => e.isbn13 == books[index].isbn13);
                  CardDetail(context).showCard(book);
                },
              );
            },
            child: CardBook(
              imgUrl: books[index].image,
              title: books[index].title,
              price: books[index].price,
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadBooks() async {
    try {
      log('Loading books ...');
      final bookApi = ref.read(bookApiProvider);
      final books = await bookApi.newBooks();
      ref.read(booksProvider.notifier).resetState();
      ref.read(booksProvider.notifier).addAll(books);
      log('Loaded books');
    } on Exception catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
    }
  }

  Future<void> _loadSearch(String query) async {
    try {
      log('Loading books ...');
      final bookApi = ref.read(bookApiProvider);
      final books = await bookApi.searchBooks(query);
      log(books.toString());
      ref.read(booksProvider.notifier).resetState();
      ref.read(booksProvider.notifier).addAll(books);
      log('Loaded books');
    } on Exception catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
    }
  }

  Future<void> _fetchMoreInfo(String isbn13) async {
    log('Fetching more info');
    try {
      final bookApi = ref.read(bookApiProvider);
      BookModel book = await bookApi.getMoreInfo(isbn13);
      ref.read(booksProvider.notifier).updateOne(book);
    } on Exception catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
    }
  }

  Future<void> updateHistory(String value) async {
    SharedPreferences prefs = await _prefs;
    searchList.add(value);
    searchList2 = searchList.reversed.toList();
    prefs.setStringList('searchList', searchList);
  }

  Future<void> getHistory() async {
    SharedPreferences prefs = await _prefs;
    searchList = prefs.getStringList('searchList') ?? [];
    searchList2 = searchList.reversed.toList();
  }

  Widget showAlertDialog() {
    return AlertDialog(
      title: const Text('No se encontraron resultados'),
      content: const Text('Intenta con otra busqueda'),
      actions: [
        TextButton(
          onPressed: () {
            _loadBooks();
          },
          child: const Text('Cerrar'),
        )
      ],
    );
  }
}
