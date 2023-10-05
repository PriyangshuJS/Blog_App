import 'package:flutter/material.dart';

import '../models/blog_model.dart';

class BlogItemWidget extends StatefulWidget {
  final BlogPost blogPost;
  final Function(BlogPost) onLikeButtonPressed;

  BlogItemWidget({
    required this.blogPost,
    required this.onLikeButtonPressed,
  });

  @override
  _BlogItemWidgetState createState() => _BlogItemWidgetState();
}

class _BlogItemWidgetState extends State<BlogItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  bool isliked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
      child: Card(
        elevation: 5,
        shadowColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  widget.blogPost.imageUrl,
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
                      child: GestureDetector(
                        child: Icon(
                          isliked
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: isliked ? Colors.red : Colors.white70,
                          size: 30,
                        ),
                        onTap: () {
                          widget.onLikeButtonPressed(widget.blogPost);
                          isliked = true;
                        },
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.blogPost.title,
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
