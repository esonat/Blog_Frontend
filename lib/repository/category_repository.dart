import '../models/Category.dart';
import 'service/category_service.dart';

class CategoryRepository {
  const CategoryRepository({
    required this.service,
  });
  final CategoryService service;

  Future<List<Category>> getCategories() async => service.getCategories();

  Future<Category> getCategoryById(int id) async => service.getCategoryById(id);

  Future<Category> addCategory(Category newCategory) =>
      service.addCategory(newCategory);

  Future<Category> updateCategory(int id, Category newCategory) async =>
      service.updateCategory(id, newCategory);

  Future<void> deleteCategory(int id) async => service.deleteCategory(id);
}
