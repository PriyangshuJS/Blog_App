import 'package:flutter/material.dart';
import '../models/blog_model.dart';

class BlogDetail extends StatelessWidget {
  final BlogPost blogPost;

  const BlogDetail({Key? key, required this.blogPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("IMAGE - ${blogPost.imageUrl}");
    print("TITLE - ${blogPost.title}");
    print("CONTENT - ${blogPost.title}");
    return Scaffold(
      appBar: AppBar(
        title: Text(blogPost.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Image.network(
                    blogPost.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  blogPost.title,
                  style: const TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
