import 'dart:convert';
import '../../models/Category.dart';
import '../../models/result_error.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CategoryService {
  CategoryService({
    http.Client? httpClient,
    this.baseUrl = 'http://localhost:8080',
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final Client _httpClient;

  Uri getUrl({
    required String url,
  }) {
    return Uri.parse('$baseUrl/$url');
  }

  Future<List<Category>> getCategories() async {
    final response = await _httpClient.get(getUrl(url: 'categories'));

    List<dynamic> categories = await json.decode(response.body);
    List<Category> result = [];

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        for (var i = 0; i < categories.length; i++) {
          result.add(Category.fromJson(categories[i]));
          print(Category.fromJson(categories[i]).toString());
        }
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingGames('Error getting categories');
    }

    return result;
  }

  Future<Category> getCategoryById(int id) async {
    final response = await _httpClient.get(
      getUrl(url: 'categories/' + id.toString()),
    );

    dynamic category = await json.decode(response.body) as dynamic;
    Category? result;

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        result = Category.fromJson(category);
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingGames('Error getting category');
    }

    return result;
  }

  Future<Category> addCategory(Category newCategory) async {
    final response = await _httpClient.post(getUrl(url: 'categories'),
        body: jsonEncode(<String, dynamic>{'Name': newCategory.name}));

    //dynamic post = await json.decode(response.body) as dynamic;
    Category? result;

    if (response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        result = Category.fromJson(jsonDecode(response.body));
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingGames('Error adding category');
    }

    return result;
  }

  Future<Category> updateCategory(int id, Category newCategory) async {
    final response = await _httpClient
        .patch(getUrl(url: 'categories/' + id.toString()), body: newCategory);
    dynamic category = await json.decode(response.body) as dynamic;

    Category? result;

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        result = Category.fromJson(category);
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingGames('Error updating category');
    }

    return result;
  }

  Future<void> deleteCategory(int id) async {
    final response =
        await _httpClient.delete(getUrl(url: 'categories/' + id.toString()));

    if (response.statusCode == 204) {
      print('Category deleted');
    } else {
      throw ErrorGettingGames('Error deleting category');
    }
  }
}
