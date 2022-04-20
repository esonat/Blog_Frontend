import 'dart:convert';

class Post {
  Post(
      {this.id,
      required this.title,
      required this.text,
      required this.category,
      required this.blogUser,
      required this.likeCount,
      required this.imagePath});

  int? id;
  String title;
  String text;
  int category;
  int blogUser;
  int likeCount;
  String imagePath;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['ID'],
      title: json['Title'],
      text: json['Text'],
      category: json['Category'],
      blogUser: json['User'],
      likeCount: json['LikeCount'],
      imagePath: json['ImagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id.toString(),
      'Title': title,
      'Text': text,
      'Category': category.toString(),
      'User': blogUser.toString(),
      'LikeCount': likeCount.toString(),
      'ImagePath': imagePath,
    };
  }

  @override
  String toString() {
    return "Title:" +
        title +
        "Text:" +
        text +
        "Category:" +
        category.toString() +
        "User:" +
        blogUser.toString() +
        "LikeCount" +
        likeCount.toString() +
        "ImagePath" +
        imagePath;
  }
}
