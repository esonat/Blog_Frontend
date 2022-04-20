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

Future<Category> addCategory(Category category) async {
  // Map<String, String> requestHeaders = {
  //   "Access-Control-Allow-Origin":"*",
  // };
  //Map<String,dynamic> jsonBody={"ID":"5","Title":"title","Text":"text","Category":"1"};

  final response = await http.post(
    Uri.parse('http://localhost:8080/categories'),
    // headers: <String, String>{
    //   'Content-Type': 'application/json; charset=UTF-8',
    // },
    body: jsonEncode(<String, dynamic>{'Name': category.name}),
  );

  // print(jsonEncode(<String, dynamic>{
  //   'Title':post.title,
  //   'Text':post.text,
  //   'Category':post.category
  // }));
  //jsonEncode(post));

  if (response.statusCode == 201) {
    return Category.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to add category");
  }
}

Future<List<Category>> allCategories() async {
  final response =
      await http.get(Uri.parse('http://localhost:8080/categories'));
  List<dynamic> categories = await json.decode(response.body);
  List<Category> result = [];

  if (response.statusCode == 200) {
    for (var i = 0; i < categories.length; i++) {
      result.add(Category.fromJson(categories[i]));
    }
  } else {
    throw Exception("Failed to load categories");
  }

  // for(var i=0;i<result.length;i++){
  //     print(result[i].toString());
  // }

  return result;
}

Future<Post>? getPost(int? id) async {
  Map<String, String> requestHeaders = {
    "Access-Control-Allow-Origin": "*",
  };

  final response =
      await http.get(Uri.parse('http://localhost:8080/posts/' + id.toString()));
  dynamic post = await json.decode(response.body) as dynamic;
  Post? result;

  // if(response.statusCode == 200) {
  //   for(var i=0;i<posts.length;i++) {
  //     result.add(Post.fromJson(posts[i]));
  //   }
  // }else {
  //   throw Exception("Failed to load posts");
  // }

  if (response.statusCode == 200) {
    result = Post.fromJson(post);
  } else {
    throw Exception("Failed to load post");
  }

  //print(result.toString());

  return result;
}

Future<List<Post>> getPostsByCategoryId(String categoryId) async {
  final response = await http
      .get(Uri.parse('http://localhost:8080/posts/categoryId/' + categoryId));
  List<dynamic> posts = await json.decode(response.body);
  List<Post> result = [];

  if (response.statusCode == 200) {
    for (var i = 0; i < posts.length; i++) {
      result.add(Post.fromJson(posts[i]));
      print(Post.fromJson(posts[i]).toString());
    }
  } else {
    throw Exception("Failed to load posts");
  }

  return result;
}

Future<List<Post>> allPosts() async {
  // Map<String, String> requestHeaders = {
  //   "Access-Control-Allow-Origin":"*",
  // };

  final response = await http.get(Uri.parse('http://localhost:8080/posts'));
  List<dynamic> posts = await json.decode(response.body);
  List<Post> result = [];

  if (response.statusCode == 200) {
    for (var i = 0; i < posts.length; i++) {
      result.add(Post.fromJson(posts[i]));
      print(Post.fromJson(posts[i]).toString());
    }
  } else {
    throw Exception("Failed to load posts");
  }

  // for(var i=0;i<result.length;i++){
  //     print(result[i].toString());
  // }

  return result;
}

Future<Post> addPost(Post post) async {
  // Map<String, String> requestHeaders = {
  //   "Access-Control-Allow-Origin":"*",
  // };
  //Map<String,dynamic> jsonBody={"ID":"5","Title":"title","Text":"text","Category":"1"};

  final response = await http.post(
    Uri.parse('http://localhost:8080/posts'),
    // headers: <String, String>{
    //   'Content-Type': 'application/json; charset=UTF-8',
    // },
    body: jsonEncode(<String, dynamic>{
      'Title': post.title,
      'Text': post.text,
      'Category': post.category,
      'User': post.blogUser,
      'LikeCount': post.likeCount,
      'ImagePath': post.imagePath,
    }),
  );

  // print(jsonEncode(<String, dynamic>{
  //   'Title':post.title,
  //   'Text':post.text,
  //   'Category':post.category
  // }));
  //jsonEncode(post));

  if (response.statusCode == 201) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to add post");
  }
}

Future<Post> updatePost(Post post) async {
  Map<String, String> requestHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Content-Type": "application/json",
  };

  print("updatePost: Post id=" + post.id.toString());

  final response = await http.patch(
    Uri.parse('http://localhost:8080/posts/' + post.id.toString()),
    headers: requestHeaders,
    // headers: <String, String>{
    //   'Content-Type': 'application/json; charset=UTF-8',
    // },
    body: jsonEncode(<String, dynamic>{
      'Title': post.title,
      'Text': post.text,
      'Category': post.category,
      'User': post.blogUser,
      'LikeCount': post.likeCount,
      'ImagePath': post.imagePath,
    }),
  );

  print('http://localhost:8080/posts/' + post.id.toString());

  if (response.statusCode == 201) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to add post");
  }
}

Future<BlogUser>? getBlogUser(int? id) async {
  Map<String, String> requestHeaders = {
    "Access-Control-Allow-Origin": "*",
  };

  final response =
      await http.get(Uri.parse('http://localhost:8080/users/' + id.toString()));
  dynamic blogUser = await json.decode(response.body) as dynamic;
  BlogUser? result;

  // if(response.statusCode == 200) {
  //   for(var i=0;i<posts.length;i++) {
  //     result.add(Post.fromJson(posts[i]));
  //   }
  // }else {
  //   throw Exception("Failed to load posts");
  // }

  if (response.statusCode == 200) {
    result = BlogUser.fromJson(blogUser);
  } else {
    throw Exception("Failed to load blogUser");
  }

  //print(result.toString());

  return result;
}

Future<BlogUser>? getBlogUserByUsername(String username) async {
  Map<String, String> requestHeaders = {
    "Access-Control-Allow-Origin": "*",
  };

  final response = await http
      .get(Uri.parse('http://localhost:8080/users/username/' + username));
  dynamic blogUser = await json.decode(response.body) as dynamic;
  BlogUser? result;

  // if(response.statusCode == 200) {
  //   for(var i=0;i<posts.length;i++) {
  //     result.add(Post.fromJson(posts[i]));
  //   }
  // }else {
  //   throw Exception("Failed to load posts");
  // }

  if (response.statusCode == 200) {
    result = BlogUser.fromJson(blogUser);
  } else {
    throw Exception("Failed to load blogUser");
  }

  //print(result.toString());

  return result;
}

Future<BlogUser>? getBlogUserById(int id) async {
  Map<String, String> requestHeaders = {
    "Access-Control-Allow-Origin": "*",
  };

  final response =
      await http.get(Uri.parse('http://localhost:8080/users/' + id.toString()));
  dynamic blogUser = await json.decode(response.body) as dynamic;
  BlogUser? result;

  print("getBlogUserById Id:" + id.toString());

  // if(response.statusCode == 200) {
  //   for(var i=0;i<posts.length;i++) {
  //     result.add(Post.fromJson(posts[i]));
  //   }
  // }else {
  //   throw Exception("Failed to load posts");
  // }

  if (response.statusCode == 200) {
    result = BlogUser.fromJson(blogUser);
  } else {
    throw Exception("Failed to load blogUser");
  }

  //print(result.toString());

  return result;
}
