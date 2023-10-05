import 'package:flutter/material.dart';

import '../models/blog_model.dart';

class BlogItemWidget1 extends StatelessWidget {
  final BlogPost blogPost;
  const BlogItemWidget1({required this.blogPost});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
      child: Card(
        elevation: 5,
        shadowColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  blogPost.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                color: const Color.fromRGBO(48, 48, 48, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        blogPost.title,
                        style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
