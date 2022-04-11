import '../models/Post.dart';
import 'service/post_service.dart';

class CategoryRepository {
  const CategoryRepository({
    required this.service,
  });
  final PostService service;

  Future<List<Post>> getPosts() async => service.getPosts();

  Future<Post> getPostById(int id) async => service.getPostById(id);

  Future<Post> addPost(Post newPost) => service.addPost(newPost);

  Future<Post> updatePost(int id, Post post) async => service.updatePost(id,post);

  Future<void> deletePost(int id) async => service.deletePost(id);
}
