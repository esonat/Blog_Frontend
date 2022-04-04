import 'dart:convert';
import '../../models/Post.dart';
import '../../models/result_error.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class PostService {
  PostService({
    http.Client? httpClient,
    this.baseUrl = 'http://localhost:8080',
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final Client _httpClient;

  Uri getUrl({
    required String url,
  }) {
    // final queryParameters = <String, String>{
    //   'key': dotenv.get('GAMES_API_KEY')
    // };
    // if (extraParameters != null) {
    //   queryParameters.addAll(extraParameters);
    // }

    return Uri.parse('$baseUrl/$url');
  }

  Future<List<Post>> getPosts() async {
    final response = await _httpClient.get(getUrl(url: 'posts'));

    List<dynamic> posts = await json.decode(response.body);
    List<Post> result = [];

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        for (var i = 0; i < posts.length; i++) {
          result.add(Post.fromJson(posts[i]));
          print(Post.fromJson(posts[i]).toString());
        }
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingGames('Error getting posts');
    }

    return result;
  }

  Future<Post> getPostById(int id) async {
    final response = await _httpClient.get(
      getUrl(url: 'posts/' + id.toString()),
    );

    dynamic post = await json.decode(response.body) as dynamic;
    Post? result;

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        result = Post.fromJson(post);
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingGames('Error getting genres');
    }

    return result;
  }

  Future<Post> addPost(Post newPost) async {
    final response = await _httpClient.post(getUrl(url: 'posts'),
        body: jsonEncode(<String, dynamic>{
          'Title': newPost.title,
          'Text': newPost.text,
          'Category': newPost.category,
          'User': newPost.blogUser,
        }));

    //dynamic post = await json.decode(response.body) as dynamic;
    Post? result;

    if (response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        result = Post.fromJson(jsonDecode(response.body));
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingGames('Error getting genres');
    }

    return result;
  }

  Future<Post> updatePost(int id, Post newPost) async {
    final response = await _httpClient
        .patch(getUrl(url: 'posts/' + id.toString()), body: newPost);
    dynamic post = await json.decode(response.body) as dynamic;

    Post? result;

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        result = Post.fromJson(post);
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingGames('Error getting games');
    }

    return result;
  }

  Future<void> deletePost(int id) async {
    final response =
        await _httpClient.delete(getUrl(url: 'posts/' + id.toString()));

    if (response.statusCode == 204) {
      print('Post deleted');
    } else {
      throw ErrorGettingGames('Error getting games');
    }
  }
}
