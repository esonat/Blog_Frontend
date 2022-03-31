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

class PostForm extends StatefulWidget {
  const PostForm({Key? key}) : super(key: key);

  @override
  PostFormState createState() {
    return PostFormState();
  }
}

class PostFormState extends State<PostForm> {
  final _formKey = GlobalKey<FormState>();

  String dropdownValue = '1';

  User? user;
  BlogUser? blogUser;

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

    //
    // items: <String>['One', 'Two', 'Free', 'Four']
    //     .map<DropdownMenuItem<String>>((String value) {
    //   return DropdownMenuItem<String>(
    //     value: value,
    //     child: Text(value),
    //   );
    // }).toList(),
    // return names.map<DropdownMenuItem<String>>((String value){
    //   return DropdownMenuItem<String>(
    //     value: value,
    //     child: Text(value),
    //   );
    // }).toList();
  }

  late Future<List<DropdownMenuItem<String>>> futureCategories;
  late Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    futureCategories = categoryNames();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    String title = 'title';
    String text = 'text';
    String categoryID = '1';

    if (user == null) {
      return LoginPage();
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Form(
        key: _formKey,
        child: Container(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Title'),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  title = value;

                  return null;
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    title = value;
                  });
                },
                onChanged: (String? value) {
                  setState(() {
                    title = value!;
                  });
                },
              ),
              const Text('Text'),
              TextFormField(
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  text = value;
                  return null;
                },
                onChanged: (String? value) {
                  setState(() {
                    text = value!;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    text = value;
                  });
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
              FutureBuilder(
                future: getBlogUserByUsername(user!.displayName!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    blogUser = snapshot.data as BlogUser;
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return const CircularProgressIndicator();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text('Processing Data')),
                      //   );
                      //  print('Before post.Title:'+title+'Text:'+text+'Category:'+dropdownValue);
                      Post post = Post(
                          title: title,
                          text: text,
                          category: int.parse(dropdownValue),
                          blogUser: blogUser!.id!);

                      futurePost = addPost(post);
                      print('Added post with title:' + title);
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/posts');
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const HomePage(title:'Blog')));
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
