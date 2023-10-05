import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/blog_model.dart';

class LikedBlogProvider extends ChangeNotifier {
  final Box _likeBlog = Hive.box("LikedBlog");
  List<BlogPost> _favblogs = [];

  List<BlogPost> get favblogs => _favblogs;

  void getDataFromHive() {
    final data = _likeBlog.keys
        .map((key) {
          final item = _likeBlog.get(key);
          return BlogPost(
            id: item['id'] ?? '',
            title: item['title'] ?? '',
            imageUrl: item['imageUrl'] ?? '',
            content: item['content'] ?? '',
            liked: item['liked'] ?? true,
          );
        })
        .toList()
        .reversed
        .toSet();

    _favblogs = data.toList();
    notifyListeners();
  }

  void addToFavorites(BlogPost blogPost) async {
    final existingItem = _likeBlog.values.firstWhere(
      (item) => item['title'] == blogPost.title,
      orElse: () => null,
    );

    if (existingItem == null) {
      final newItem = {
        "id": blogPost.id,
        "title": blogPost.title,
        "imageUrl": blogPost.imageUrl,
        "content": blogPost.content,
        "liked": true,
      };
      await _likeBlog.add(newItem);
      getDataFromHive();
    }
  }

  void removeFromFavorites(String title) async {
    final key = _likeBlog.keys.firstWhere(
      (key) {
        final item = _likeBlog.get(key);
        return item['title'] == title;
      },
      orElse: () => null,
    );

    if (key != null) {
      await _likeBlog.delete(key);
      getDataFromHive();
    }
  }
}
