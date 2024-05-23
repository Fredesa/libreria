import 'package:flutter/material.dart';

class CardBook extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String price;

  const CardBook(
      {Key? key,
      required this.imgUrl,
      required this.title,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightGreen[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Image.network(
              imgUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
