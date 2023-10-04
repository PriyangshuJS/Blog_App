import 'package:flutter/material.dart';

class BlogItemWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String content;
  final bool liked;

  BlogItemWidget({
    required this.content,
    required this.title,
    required this.imageUrl,
    required this.liked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SizedBox(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      liked ? Icons.favorite : Icons.favorite_border_outlined,
                      color: liked ? Colors.red : null,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite_border_outlined),
                    onPressed: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
