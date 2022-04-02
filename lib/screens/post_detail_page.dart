import 'dart:async';
import 'dart:convert';
import '../models/Post.dart';
import '../models/Category.dart';
import '../models/BlogUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:path/path.dart';
//import 'auth/Registration.dart';
import '../util/CustomAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart'; // new
import '../screens/login_page.dart';
import '../screens/profile_page.dart';
import '../screens/register_page.dart';
import '../firebase_options.dart'; // new
import '../api/api.dart';
import '../screens/post_detail_page.dart';
import '../util/arguments.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key}) : super(key: key);

  static const routeName = '/postdetail';
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided  parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Future<Post> futurePost;
  User? user;
  //int id=0;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  Widget postWidget(Post post) {
    List<Widget> children = [];

    children.add(
      Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(post.title,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w700))),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              Expanded(
                child: Text(post.text,
                    style: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.w300)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(user!.displayName!,
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(children: [
            Expanded(
              child: FutureBuilder<BlogUser>(
                future: getBlogUserByUsername(user!.displayName!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    BlogUser blogUser = snapshot.data as BlogUser;
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                              width: 50.0,
                              height: 50.0,
                              child:
                                  Image(image: AssetImage(blogUser.imagePath))),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  //   return Text(blogUser!.username);
                  // } else if (snapshot.hasError) {
                  //   return Text('${snapshot.error}');
                  // }

                  return const CircularProgressIndicator();
                },
              ),
            )
          ])
        ],
      ),
    );

    return Container(
      width: 500,
      child: Column(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as IdParameter;

    if (user == null) {
      return LoginPage();
    }

    return Scaffold(
      // appBar:AppBar(
      //   title: Text('Post Detail'),
      // ),
      appBar: const CustomAppBar(),
      body: Center(
          child: FutureBuilder<Post>(
              future: getPost(args.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return postWidget(snapshot.data!);

                  ///return Text(snapshot.data![0].title);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              })),
    );
  }
}
