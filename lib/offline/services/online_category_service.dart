import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:lakasir/api/responses/categories/category_response.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_category_model.dart';
import 'package:lakasir/offline/services/category_service_interface.dart';
import 'package:lakasir/services/category_service.dart' as api;

class OnlineCategoryService implements CategoryServiceInterface {
  final _isar = LakasirDatabase.isar;
  final _apiService = api.CategoryService();

  @override
  Future<List<OfflineCategory>> getCategories() async {
    try {
      final response = await _apiService.getCategories();
      await _cacheCategories(response);
    } catch (_) {
      // Silently fall back to cache on API failure
    }

    return await _getCachedCategories();
  }

  @override
  Future<OfflineCategory?> getCategoryById(int id) async {
    return await _isar.offlineCategorys.get(id);
  }

  @override
  Future<OfflineCategory> createCategory(OfflineCategory category) async {
    try {
      await _apiService.addCategory(category.name);
      category.isLocal = false;
    } catch (_) {
      category
        ..isLocal = true
        ..cachedAt = DateTime.now();
    }

    await _isar.writeTxn(() async {
      await _isar.offlineCategorys.put(category);
    });

    return category;
  }

  @override
  Future<OfflineCategory> updateCategory(OfflineCategory category) async {
    try {
      await _apiService.updateCategory(category.id, category.name);
      category.isLocal = false;
    } catch (_) {
      category
        ..isLocal = true
        ..cachedAt = DateTime.now();
    }

    await _isar.writeTxn(() async {
      await _isar.offlineCategorys.put(category);
    });

    return category;
  }

  @override
  Future<void> deleteCategory(int id) async {
    try {
      await _apiService.deleteCategory(id);
    } catch (_) {
      // Ignore API failure, delete locally regardless
    }

    await _isar.writeTxn(() async {
      await _isar.offlineCategorys.delete(id);
    });
  }

  Future<void> _cacheCategories(RxList<CategoryResponse> categories) async {
    final cached = categories.map((c) {
      return OfflineCategory()
        ..id = c.id
        ..name = c.name
        ..cachedAt = DateTime.now()
        ..isLocal = false;
    }).toList();

    await _isar.writeTxn(() async {
      await _isar.offlineCategorys.putAll(cached);
    });
  }

  Future<List<OfflineCategory>> _getCachedCategories() async {
    return await _isar.offlineCategorys.where().findAll();
  }
}