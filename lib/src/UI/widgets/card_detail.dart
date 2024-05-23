import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:libreria/src/UI/widgets/detail_laber.dart';
import 'package:libreria/src/domain/models/book_model.dart';

class CardDetail {
  CardDetail(this.context);
  final BuildContext context;
  late BookModel book;

  void showCard(BookModel book) {
    this.book = book;
    showGeneralDialog<void>(
      context: context,
      barrierLabel: '',
      barrierColor: Colors.green.withOpacity(0.20),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation1,
        Animation<double> animation2,
      ) {
        Widget element = _infoWidget(context, book);

        return WillPopScope(
          onWillPop: () async => true,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: element,
          ),
        );
      },
    );
  }
}

Widget _infoWidget(BuildContext context, BookModel book) {
  return Container(
      key: const Key('card_detail'),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 120),
      child: SingleChildScrollView(
          child: Material(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close))),
                  SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Image.network(
                              book.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback widget when the image fails to load
                                return Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey[700],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Titulo: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  book.title,
                                  style: const TextStyle(fontSize: 16),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Detalles',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DetailLabel(
                              label: 'Subtitulo:', value: book.subtitle ?? ''),
                          const SizedBox(
                            height: 10,
                          ),
                          DetailLabel(
                              label: 'Autores:', value: book.authors ?? ''),
                          const SizedBox(
                            height: 10,
                          ),
                          DetailLabel(
                              label: 'Cantidad de paginas:',
                              value: book.pages ?? ''),
                          const SizedBox(
                            height: 10,
                          ),
                          DetailLabel(
                              label: 'Año de lanzamiento:',
                              value: book.year ?? ''),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Valoracion: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                        int.parse(book.rating ?? ''),
                                        (index) => const Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ))),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DetailLabel(
                              label: 'Codigo ISBN10:',
                              value: book.isbn10 ?? ''),
                          const SizedBox(
                            height: 10,
                          ),
                          DetailLabel(
                              label: 'Codigo ISBN13:', value: book.isbn13),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Descripcion:',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            book.desc ?? '',
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )),
                ],
              ))));
}
