class BlogPost {
  final String id;
  final String title;
  final String imageUrl;
  final String content;
  final bool liked;

  BlogPost(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.content,
      required this.liked});
}
