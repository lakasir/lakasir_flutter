import 'package:get/get.dart';
import 'package:lakasir/offline/models/offline_category_model.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/offline/services/category_service_interface.dart';
import 'package:lakasir/offline/services/offline_category_service.dart';
import 'package:lakasir/offline/services/online_category_service.dart';

class CategoryRepository implements CategoryServiceInterface {
  late final OfflineCategoryService _offlineService = OfflineCategoryService();
  late final OnlineCategoryService _onlineService = OnlineCategoryService();

  CategoryServiceInterface get _service =>
      Get.find<AppModeService>().isOnline ? _onlineService : _offlineService;

  @override
  Future<List<OfflineCategory>> getCategories() {
    return _service.getCategories();
  }

  @override
  Future<OfflineCategory?> getCategoryById(int id) {
    return _service.getCategoryById(id);
  }

  @override
  Future<OfflineCategory> createCategory(OfflineCategory category) {
    return _service.createCategory(category);
  }

  @override
  Future<OfflineCategory> updateCategory(OfflineCategory category) {
    return _service.updateCategory(category);
  }

  @override
  Future<void> deleteCategory(int id) {
    return _service.deleteCategory(id);
  }
}