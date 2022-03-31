class BlogUser {
  final int? id;
  final String username;
  final String imagePath;

  BlogUser({
    this.id,
    required this.username,
    required this.imagePath,
  });

  factory BlogUser.fromJson(Map<String, dynamic> json) {
    return BlogUser(
      id: json['ID'],
      username: json['Username'],
      imagePath: json['ImagePath'],
    );
  }
}
