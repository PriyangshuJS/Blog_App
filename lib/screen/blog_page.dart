import 'dart:convert';
import 'package:blogapp/screen/blog_detail.dart';

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

    setState(() {
      _favblogs = data.toList();
      print("FAVBLOG- ${_favblogs[0].imageUrl}");
    });
  }

  Future<void> _blogDownload({
    required String id,
    required String title,
    required String imageUrl,
    required String content,
    required bool liked,
  }) async {
    final existingItem = _likeBlog.values.firstWhere(
      (item) => item['title'] == title,
      orElse: () => null,
    );

    if (existingItem == null) {
      final newItem = {
        "id": id,
        "title": title,
        "imageUrl": imageUrl,
        "content": content,
        "liked": true,
      };
      await _likeBlog.add(newItem);
      _getDataHive();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text(
              'Article - $title added to Favorites',
              style: const TextStyle(fontSize: 12),
            ),
          );
        },
      );
      print("No of offline BLOG - ${_likeBlog.length}");
    } else {
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text(
              'Article - $title already there in your Favorites',
              style: const TextStyle(fontSize: 12),
            ),
          );
        },
      );
    }
  }

  Future<void> _deleteBlog({required String title}) async {
    final key = _likeBlog.keys.firstWhere(
      (key) {
        final item = _likeBlog.get(key);
        return item['title'] == title;
      },
      orElse: () => null,
    );

    if (key != null) {
      await _likeBlog.delete(key);
      _getDataHive();
      print("ADTER DEL LEN -${_likeBlog.length}");
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              title: Text(
                'Article - $title removed from Favourites',
                style: const TextStyle(fontSize: 12),
              ),
            );
          });
    }
  }

  Future<void> fetchBlogs() async {
    final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    const String adminSecret =
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
            id: data['id'] ?? '',
            title: data['title'] ?? '',
            imageUrl: data['image_url'] ?? '',
            content: data['content'] ?? '',
            liked: false,
          );
        }).toList();
        print('Response data: ${response.body}');
        setState(() {
          blogPosts = posts;
        });
      } else {
        print('Request failed with status code: ${response.statusCode}');
        print('Response data: ${response.body}');

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Sorry User "),
              content: const Text(
                  "Failed to fetch blogs, this time. \nPlease try again later."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Sorry User!"),
            content: const Text(
                "An error occurred, it can be due to internet connectivity or some problem from our side.\nPlease try again later."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Color.fromRGBO(48, 48, 48, 1),
            tabs: [
              Tab(
                  icon: Icon(
                Icons.article,
                size: 35,
              )),
              Tab(
                  icon: Icon(
                Icons.favorite,
                size: 35,
              )),
            ],
          ),
          title: const Text(
            'Blog and Articles',
            style: TextStyle(fontSize: 24),
          ),
          backgroundColor: Color.fromRGBO(33, 33, 33, 1),
          iconTheme:
              const IconThemeData(color: Color.fromRGBO(222, 219, 204, 1)),
          titleTextStyle:
              const TextStyle(color: Color.fromRGBO(222, 219, 204, 1)),
        ),
        backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
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
                            id: post.id,
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
            _favblogs.isEmpty
                ? const Center(
                    child: Text(
                      "You have not liked any Blogs or Articles Yet!",
                      style: TextStyle(color: Color.fromRGBO(222, 219, 204, 1)),
                    ),
                  )
                : ListView.builder(
                    itemCount: _favblogs.length,
                    itemBuilder: (context, index) {
                      final likedBlog = _favblogs[index]; // Get the key

                      return Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        height: 300,
                        child: InkWell(
                          onDoubleTap: () =>
                              _deleteBlog(title: likedBlog.title),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlogDetail(
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
                    },
                  )
          ],
        ),
      ),
    );
  }
}
