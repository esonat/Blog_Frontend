import '../models/BlogUser.dart';
import 'service/user_service.dart';

class UserRepository {
  const UserRepository({
    required this.service,
  });
  final BlogUserService service;

  Future<List<BlogUser>> getUsers() async => service.getBlogUsers();

  Future<BlogUser> getUserById(int id) async => service.getBlogUserById(id);

  Future<BlogUser> addUser(BlogUser user) => service.addBlogUser(user);

  Future<BlogUser> updateUser(int id, BlogUser newUser) async =>
      service.updateBlogUser(id, newUser);

  Future<void> deleteUser(int id) async => service.deleteBlogUser(id);
}
