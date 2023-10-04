import 'package:flutter/material.dart';

import '../../models/blog_model.dart';

class Favourites extends StatelessWidget {
  final BlogPost
      blogPost; // This will hold the data received from the previous page

  Favourites({Key? key, required this.blogPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("IMAGE - ${blogPost.imageUrl}");
    print("TITLE - ${blogPost.title}");
    print("CONTENT - ${blogPost.content}");
    return Scaffold(
        appBar: AppBar(
          title: Text(blogPost.title), // Display the title in the app bar
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1, // The image will take up 1/3 of the available space
              child: Image.network(blogPost.imageUrl),
            ),
            Expanded(
              flex: 2, // The content will take up 2/3 of the available space
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  blogPost.content,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ));
  }
}
