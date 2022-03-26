import 'package:cloud_firestore/cloud_firestore.dart';

class User{

  final String id;
  final String profileName;
  final String userName;
  final String email;

  User({
    required this.id,
    required this.profileName,
    required this.userName,
    required this.email,
  });

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
        id: doc['id'],
        profileName: doc['profileName'],
        userName: doc['userName'],
        email: doc['email'],
    );
  }
}
