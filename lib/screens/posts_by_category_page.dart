import 'dart:async';
import 'dart:convert';
import 'package:like_button/like_button.dart';

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

class PostsByCategory extends StatefulWidget {
  const PostsByCategory({Key? key, required this.categoryId}) : super(key: key);

  final String categoryId;

  @override
  State<PostsByCategory> createState() => _PostsByCategoryState();
}

class _PostsByCategoryState extends State<PostsByCategory> {
  User? user;
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = getPostsByCategoryId('1');
    user = FirebaseAuth.instance.currentUser;
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      futurePosts = allPosts();
    });
  }

  Widget postWidgetList(List<Post> posts, BuildContext context) {
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No one signed in');
    } else {
      print('Current user:' + user!.email!);
    }

    List<Widget> children = [];
    List<int> idList = [];
    BlogUser? blogUser;

    for (var i = 0; i < posts.length; i++) {
      children.add(
        Row(
          children: [
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      print("Id:" + posts[i].id.toString());
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PostDetailPage(id: posts[i].id)))
                          .then(onGoBack);
                    },
                    child: Text(posts[i].title,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w700)))),
          ],
        ),
      );

      children.add(
        Row(
          children: [
            Expanded(
                child: Text(posts[i].text,
                    style: const TextStyle(fontSize: 15.0))),
          ],
        ),
      );

      children.add(
        FutureBuilder<BlogUser>(
          future: getBlogUserById(posts[i].blogUser),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("BlogUser:" + blogUser.toString());
              blogUser = snapshot.data as BlogUser;
              return Text(blogUser!.username);
            } else if (snapshot.hasError) {
              print('getBlogUserById snapshot error');
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      );

      children.add(Row(children: [
        Expanded(
          child: FutureBuilder<BlogUser>(
            future: getBlogUserById(posts[i].blogUser),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("BlogUser:" + blogUser.toString());
                blogUser = snapshot.data as BlogUser;
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                          width: 50.0,
                          height: 50.0,
                          child: Image(image: AssetImage(blogUser!.imagePath))),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                print('getBlogUserById image snapshot error');
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        )
      ]));

      children.add(const SizedBox(height: 50));
    }

    return Container(
      width: 500,
      child: Column(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as IdParameter;

    if (user == null) {
      return LoginPage();
    }

    return Scaffold(
      // appBar:AppBar(
      //   title: Text('Post Detail'),
      // ),
      appBar: const CustomAppBar(),
      body: Center(
          child: FutureBuilder<List<Post>>(
              // future: getPost(args.id),
              future: getPostsByCategoryId(widget.categoryId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return postWidgetList(snapshot.data!, context);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              })),
    );
  }
}
