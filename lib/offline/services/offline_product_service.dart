import 'package:isar/isar.dart';
import 'package:lakasir/api/requests/product_request.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_category_model.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';
import 'package:lakasir/offline/services/product_service_interface.dart';

class OfflineProductService implements ProductServiceInterface {
  final _isar = LakasirDatabase.isar;

  @override
  Future<List<OfflineProduct>> getProducts({ProductRequest? request}) async {
    List<OfflineProduct> products;
    if (request?.name != null && request!.name!.isNotEmpty) {
      products = await _isar.offlineProducts
          .where()
          .filter()
          .nameContains(request.name!, caseSensitive: false)
          .findAll();
    } else if (request?.categoryId != null && request!.categoryId!.isNotEmpty) {
      products = await _isar.offlineProducts
          .where()
          .filter()
          .categoryIdEqualTo(int.parse(request.categoryId!))
          .findAll();
    } else {
      products = await _isar.offlineProducts.where().findAll();
    }

    await _populateCategoryNames(products);
    return products;
  }

  @override
  Future<OfflineProduct?> getProductById(int id) async {
    final product = await _isar.offlineProducts.get(id);
    if (product != null) {
      await _populateCategoryNames([product]);
    }
    return product;
  }

  Future<void> _populateCategoryNames(List<OfflineProduct> products) async {
    final categoryIds = products
        .map((p) => p.categoryId)
        .whereType<int>()
        .toSet()
        .toList();
    if (categoryIds.isEmpty) return;
    final categories = await _isar.offlineCategorys.getAll(categoryIds);
    final categoryMap = <int, String>{};
    for (final cat in categories.whereType<OfflineCategory>()) {
      categoryMap[cat.id] = cat.name;
    }
    for (final product in products) {
      if (product.categoryId != null && categoryMap.containsKey(product.categoryId)) {
        product.categoryName = categoryMap[product.categoryId]!;
      }
    }
  }

  @override
  Future<OfflineProduct> createProduct(OfflineProduct product) async {
    final count = await _isar.offlineProducts.count();
    product
      ..id = -(count + 1)
      ..isLocal = true
      ..cachedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.offlineProducts.put(product);
    });

    return product;
  }

  @override
  Future<OfflineProduct> updateProduct(OfflineProduct product) async {
    product
      ..isLocal = true
      ..cachedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.offlineProducts.put(product);
    });

    return product;
  }

  @override
  Future<void> deleteProduct(int id) async {
    await _isar.writeTxn(() async {
      await _isar.offlineProducts.delete(id);
    });
  }
}