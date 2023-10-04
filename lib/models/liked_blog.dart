import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class BlogModel extends HiveObject {
  @HiveField(0)
  final int id; // Add the 'id' field

  @HiveField(1)
  final String imageUrl;

  @HiveField(2)
  final String title;

  @HiveField(3)
  bool liked; // Add the 'liked' field

  BlogModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.liked = false,
  });
}
