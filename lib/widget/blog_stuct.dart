import 'package:flutter/material.dart';

import '../models/blog_model.dart';

class BlogItemWidget extends StatelessWidget {
  final bool liked;
  final BlogPost blogPost;
  const BlogItemWidget({required this.liked, required this.blogPost});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        liked ? Icons.favorite : Icons.favorite_border_outlined,
                        color: liked ? Colors.red : Colors.white70,
                        size: 30,
                      ),
                    ),
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
