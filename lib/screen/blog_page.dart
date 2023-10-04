import 'dart:convert';
import 'package:blogapp/screen/blog_detail.dart';
import 'package:blogapp/screen/favourites.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../models/blog_model.dart';
import '../widget/blog_stuct.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<BlogPost> blogPosts = [];

  @override
  void initState() {
    super.initState();
    fetchBlogs();
    _getDataHive();
  }

  final _likeBlog = Hive.box("LikedBlog");

  List<BlogPost> _favblogs = [];
  void _getDataHive() {
    final data = _likeBlog.keys
        .map((key) {
          final item = _likeBlog.get(key);
          return BlogPost(
            title: item['title'] ?? '',
            imageUrl: item['imageUrl'] ?? '',
            content: item['content'] ?? '',
            liked: true,
          );
        })
        .toList()
        .reversed
        .toSet();

    setState(() {
      _favblogs = data.toList();
      print("FAVBLOG- ${_favblogs[0].imageUrl}");
    });
  }

  Future<void> _blogDownload({
    required String title,
    required String imageUrl,
    required String content,
    required bool liked,
  }) async {
    final newItem = {
      "title": title,
      "imageUrl": imageUrl,
      "content": content,
      "liked": liked,
    };
    await _likeBlog.add(newItem);
    _getDataHive();
    print("No of offline BLOG - ${_likeBlog.length}");
  }

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
        print('Response data: ${response.body}');
        final List<BlogPost> posts = blogData.map((data) {
          return BlogPost(
            title: data['title'] ?? '',
            imageUrl: data['image_url'] ?? '',
            content: data['content'] ?? '',
            liked: false,
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.article)),
              Tab(icon: Icon(Icons.favorite)),
            ],
          ),
          title: const Text('Blog and Articles'),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Display blogs from the API
            blogPosts.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: blogPosts.length,
                    itemBuilder: (context, index) {
                      final post = blogPosts[index];
                      return Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        height: 300,
                        child: InkWell(
                          onDoubleTap: () => _blogDownload(
                            title: post.title,
                            imageUrl: post.imageUrl,
                            content: post.content,
                            liked: post.liked,
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlogDetail(
                                blogPost: post,
                              ),
                            ),
                          ),
                          child: BlogItemWidget(
                            title: post.title,
                            imageUrl: post.imageUrl,
                            content: post.content,
                            liked: post.liked,
                          ),
                        ),
                      );
                    },
                  ),

            // Tab 2: Display liked blogs from Hive

            _likeBlog.length == 0
                ? const Center(
                    child:
                        Text("You have not liked any Blogs or Articles Yet!"),
                  )
                : ListView.builder(
                    itemCount: _favblogs.length,
                    itemBuilder: (context, index) {
                      final likedBlog = _favblogs[index]; // Get the key
                      // Retrieve the item using the key
                      if (likedBlog != null) {
                        return Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: 300,
                          child: InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Favourites(
                                  blogPost: likedBlog,
                                ),
                              ),
                            ),
                            child: BlogItemWidget(
                              title: likedBlog.title,
                              imageUrl: likedBlog.imageUrl,
                              content: likedBlog.content,
                              liked: likedBlog.liked,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink(); // Handle null values
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }
}
