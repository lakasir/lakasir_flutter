import 'package:isar/isar.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_category_model.dart';
import 'package:lakasir/offline/services/category_service_interface.dart';

class OfflineCategoryService implements CategoryServiceInterface {
  final _isar = LakasirDatabase.isar;

  @override
  Future<List<OfflineCategory>> getCategories() async {
    return await _isar.offlineCategorys.where().findAll();
  }

  @override
  Future<OfflineCategory?> getCategoryById(int id) async {
    return await _isar.offlineCategorys.get(id);
  }

  @override
  Future<OfflineCategory> createCategory(OfflineCategory category) async {
    final count = await _isar.offlineCategorys.count();
    category
      ..id = -(count + 1)
      ..isLocal = true
      ..cachedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.offlineCategorys.put(category);
    });

    return category;
  }

  @override
  Future<OfflineCategory> updateCategory(OfflineCategory category) async {
    category
      ..isLocal = true
      ..cachedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.offlineCategorys.put(category);
    });

    return category;
  }

  @override
  Future<void> deleteCategory(int id) async {
    await _isar.writeTxn(() async {
      await _isar.offlineCategorys.delete(id);
    });
  }
}