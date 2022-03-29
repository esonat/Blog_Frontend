import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String userName;

  User({
    required this.id,
    required this.userName,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      userName: doc['userName'],
    );
  }
}
