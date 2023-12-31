import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/blog_model.dart';
import '../widget/blog_struct1.dart';
import '../widget/blog_stuct.dart';
import 'blog_detail.dart';

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
      //print("FAVBLOG- ${_favblogs[0].imageUrl}");
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

      print("No of offline BLOG - ${_likeBlog.length}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article added to Favorites'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article present in Favorites'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _deleteBlog({required String title}) async {
    final key = _likeBlog.keys.firstWhere(
      (key) {
        final item = _likeBlog.get(key);
        print("DELEC=TE iitem -${item['title']}");
        print("TITLE_$title");
        return item['title'] == title;
      },
      orElse: () => null,
    );

    if (key != null) {
      await _likeBlog.delete(key);
      setState(() {
        _getDataHive();
      });
      print("AFTER DEL LEN - ${_likeBlog.length}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article removed from Favorites'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> fetchBlogs() async {
    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
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
            content: Text("An error occurred,\n$e"),
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
          backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
          iconTheme:
              const IconThemeData(color: Color.fromRGBO(222, 219, 204, 1)),
          titleTextStyle:
              const TextStyle(color: Color.fromRGBO(222, 219, 204, 1)),
        ),
        backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
        body: TabBarView(
          children: [
            // Tab 1: Blogs from the API
            blogPosts.length == 0
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
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlogDetail(
                                blogPost: post,
                              ),
                            ),
                          ),
                          child: BlogItemWidget(
                            blogPost: post,
                            onLikeButtonPressed: (blogPost) {
                              _blogDownload(
                                id: blogPost.id,
                                title: blogPost.title,
                                imageUrl: blogPost.imageUrl,
                                content: blogPost.content,
                                liked: blogPost.liked,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),

            // Tab 2: Displaying liked blogs that are stored offline in Hive
            _favblogs.isEmpty
                ? const Center(
                    child: Text(
                      "You have not liked any Blogs or Articles Yet!",
                      style: TextStyle(
                          color: Color.fromRGBO(222, 219, 204, 1),
                          fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _favblogs.length,
                    itemBuilder: (context, index) {
                      final likedBlog = _favblogs[index];

                      return Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        height: 300,
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlogDetail(
                                blogPost: likedBlog,
                              ),
                            ),
                          ),
                          onDoubleTap: () =>
                              _deleteBlog(title: likedBlog.title),
                          child: BlogItemWidget1(
                            blogPost: likedBlog,
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
