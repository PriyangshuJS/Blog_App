import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/blog_model.dart';
import '../widget/blog_stuct.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<BlogPost> blogPosts = [];

  Future<void> fetchBlogs() async {
    final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    final String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> blogData = jsonData['blogs'];

        final List<BlogPost> posts = blogData.map((data) {
          return BlogPost(
            title: data['title'] ?? '',
            imageUrl: data['image_url'] ?? '',
            content: data['content'] ?? '',
          );
        }).toList();

        setState(() {
          blogPosts = posts;
        });
      } else {
        // Request failed
        print('Request failed with status code: ${response.statusCode}');
        print('Response data: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: blogPosts.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Blog and Articles'),
        ),
        body: ListView.builder(
          itemCount: blogPosts.length,
          itemBuilder: (context, index) {
            final post = blogPosts[index];
            return BlogItemWidget(
              title: post.title,
              imageUrl: post.imageUrl,
              content: post.content,
            );
          },
        ),
      ),
    );
  }
}
