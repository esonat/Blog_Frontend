import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/User.dart';
import '../main.dart';

class Auth{
  FirebaseAuth auth = FirebaseAuth.instance;
  

}
//   final auth.FirebaseAuth _auth=auth.FirebaseAuth.instance;
//   final firebaseUser = auth.FirebaseAuth.instance.currentUser;
//
//   User _userFromFirebaseUser(auth.User user){
//       return user != null ? User(id: user.uid) : null;
//   }
// }
