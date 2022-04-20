import 'dart:async';
import 'dart:convert';
import 'package:blog/screens/posts_by_category_page.dart';
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
  late Future<List<DropdownMenuItem<String>>> futureCategories;
  String dropdownValue = '1';

  Future<List<DropdownMenuItem<String>>> categoryNames() async {
    List<Category> categories = await allCategories();
    List<DropdownMenuItem<String>> list = [];
    List<String> names = [];

    if (categories != null) {
      for (var i = 0; i < categories.length; i++) {
        list.add(DropdownMenuItem<String>(
          value: categories[i].id.toString(),
          child: Text(categories[i].name),
        ));

        names.add(categories[i].name);
      }
    }

    return list;
  }

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
    futureCategories = categoryNames();
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
              //   return Text(blogUser!.username);
              // } else if (snapshot.hasError) {
              //   return Text('${snapshot.error}');
              // }

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
      body: GridView.count(
        crossAxisCount: 3,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<Post>>(
              future: futurePosts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("TRUE");
                  print(snapshot);

                  List<Post> postList = snapshot.data! as List<Post>;

                  return postWidgetList(postList, context);
                } else if (snapshot.hasError) {
                  print("Snapshot error");
                  //                return Text('${snapshot.error}');
                  return const CircularProgressIndicator();
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
        ],

        //child: SingleChildScrollView(
        //child:(
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Blog'),
            ),
            ListTile(
              title: const Text('Create Post'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/createPost');
              },
            ),
            ListTile(
              title: const Text('Create Category'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/createCategory');
              },
            ),
            FutureBuilder(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        Navigator.pop(context);
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PostsByCategory(categoryId: newValue)))
                            .then(onGoBack);
                      });
                    },
                    items: snapshot.data! as List<DropdownMenuItem<String>>,
                    // items: <String>['One', 'Two', 'Free', 'Four']
                    //     .map<DropdownMenuItem<String>>((String value) {
                    //   return DropdownMenuItem<String>(
                    //     value: value,
                    //     child: Text(value),
                    //   );
                    // }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
