import 'dart:async';
import 'dart:convert';
import 'package:blog/screens/post_detail_page.dart';

import 'models/Post.dart';
import 'models/Category.dart';
import 'models/BlogUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:path/path.dart';
//import 'auth/Registration.dart';
import 'util/CustomAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // new
import '../screens/login_page.dart';
import '../screens/profile_page.dart';
import '../screens/register_page.dart';
import 'firebase_options.dart'; // new
import '../screens/home_page.dart';
import '../screens/post_form.dart';
import '../screens/category_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      //home:const HomePage(title:'Blog'),
      //  body: const HomePage(title: 'Blog'),
      title: 'Blog',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //  home: const HomePage(title: 'Blog'),
      initialRoute: '/login',
      routes: {
        '/posts': (context) => const HomePage(title: 'Blog'),
        '/postdetail': (context) => const PostDetailPage(),
        '/createPost': (context) => const PostForm(),
        '/createCategory': (context) => const CategoryForm(),
        '/login': (context) => LoginPage(),
        '/profile': (context) => ProfilePage(user: currentUser!),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
//
// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Blog'),
//       ),
//     );
//   }
// }

String? getCurrentRoute(BuildContext context) {
  var route = ModalRoute.of(context);

  if (route != null) {
    print("Current Route:" + route.settings.name!);
    return route.settings.name;
  }

  return null;
}
