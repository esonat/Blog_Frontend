import 'dart:convert';
import '../../models/BlogUser.dart';
import '../../models/result_error.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class BlogUserService {
  BlogUserService({
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

  Future<List<BlogUser>> getBlogUsers() async {
    final response = await _httpClient.get(getUrl(url: 'users'));

    List<dynamic> BlogUsers = await json.decode(response.body);
    List<BlogUser> result = [];

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        for (var i = 0; i < BlogUsers.length; i++) {
          result.add(BlogUser.fromJson(BlogUsers[i]));
          print(BlogUser.fromJson(BlogUsers[i]).toString());
        }
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingGames('Error getting users');
    }

    return result;
  }

  Future<BlogUser> getBlogUserById(int id) async {
    final response = await _httpClient.get(
      getUrl(url: 'users/' + id.toString()),
    );

    dynamic user = await json.decode(response.body) as dynamic;
    BlogUser? result;

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        result = BlogUser.fromJson(user);
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingGames('Error getting user');
    }

    return result;
  }

  Future<BlogUser> addBlogUser(BlogUser newBlogUser) async {
    final response = await _httpClient.post(getUrl(url: 'users'),
        body: jsonEncode(<String, dynamic>{
          'Username': newBlogUser.username,
          'ImagePath': newBlogUser.imagePath,
        }));

    //dynamic BlogUser = await json.decode(response.body) as dynamic;
    BlogUser? result;

    if (response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        result = BlogUser.fromJson(jsonDecode(response.body));
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingGames('Error adding user');
    }

    return result;
  }

  Future<BlogUser> updateBlogUser(int id, BlogUser newBlogUser) async {
    final response = await _httpClient
        .patch(getUrl(url: 'users/' + id.toString()), body: newBlogUser);
    dynamic user = await json.decode(response.body) as dynamic;

    BlogUser? result;

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        result = BlogUser.fromJson(user);
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingGames('Error updating user');
    }

    return result;
  }

  Future<void> deleteBlogUser(int id) async {
    final response =
        await _httpClient.delete(getUrl(url: 'users/' + id.toString()));

    if (response.statusCode == 204) {
      print('BlogUser deleted');
    } else {
      throw ErrorGettingGames('Error deleting user');
    }
  }
}
