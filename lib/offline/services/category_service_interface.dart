import 'package:lakasir/offline/models/offline_category_model.dart';

abstract class CategoryServiceInterface {
  Future<List<OfflineCategory>> getCategories();
  Future<OfflineCategory?> getCategoryById(int id);
  Future<OfflineCategory> createCategory(OfflineCategory category);
  Future<OfflineCategory> updateCategory(OfflineCategory category);
  Future<void> deleteCategory(int id);
}