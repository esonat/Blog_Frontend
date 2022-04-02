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

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided  parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Post>> futurePosts;

  User? user;
  // handlePosts(List<Post> content){
  //   for(var i=0;i<content.length;i++){
  //     print(content[i].toString());
  //   }
  // }
  @override
  void initState() {
    super.initState();
    futurePosts = allPosts();
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
                      Navigator.pushNamed(context, PostDetailPage.routeName,
                              arguments: IdParameter(posts[i].id))
                          .then(onGoBack);
                    },
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const PostDetailPage(),
                    //       settings: RouteSettings(
                    //         arguments: IdParameter(posts[i].id),
                    //       ),
                    //     ),
                    //   ).then(onGoBack);
                    // },
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
      ]));

      // children.add(
      //   Row(
      //     children: [
      //       Expanded(child: Image.network(blogUser!.imagePath)),
      //     ],
      //   ),
      // );

      children.add(const SizedBox(height: 50));
    }
    return Container(
      width: 500,
      child: Column(children: children),
    );
    //child: Column(children:children),
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    // if (user == null) {
    //   Navigator.of(context).pushNamed('/login');
    // }

    return Scaffold(
      appBar: const CustomAppBar(
          // appBar: AppBar(
          //   //Here we take the value from the MyHomePage object that was created by
          //   //the App.build method, and use it to set our appbar title.
          //   title: Text(widget.title),
          //   actions: <Widget>[
          //     TextButton(
          //       child: const Text(
          //         'Create Post',
          //         textAlign:TextAlign.start,
          //         style: TextStyle(fontSize: 18.0, color: Colors.white)),
          //       onPressed: () {
          //         // Navigator.push(
          //         //   context,
          //         //   MaterialPageRoute(builder: (context) => const PostForm())).then((value) { setState(() {} );});
          //         // },
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => const PostForm())).then((value) { onGoBack(value);});
          //         },
          //       ),
          //     ],
          //       //    Navigator.push(context,MaterialPageRoute(builder: (context) => const PostForm())).then((value) { setState(() {} }));
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Post>>(
            future: futurePosts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("TRUE");
                print(snapshot);

                List<Post> postList = snapshot.data! as List<Post>;

                return postWidgetList(postList, context);

                ///return Text(snapshot.data![0].title);
              } else if (snapshot.hasError) {
                print("Snapshot error");
                //                return Text('${snapshot.error}');
                return const CircularProgressIndicator();
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
