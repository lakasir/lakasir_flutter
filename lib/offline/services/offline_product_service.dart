import 'package:isar/isar.dart';
import 'package:lakasir/api/requests/product_request.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';
import 'package:lakasir/offline/services/product_service_interface.dart';

class OfflineProductService implements ProductServiceInterface {
  final _isar = LakasirDatabase.isar;

  @override
  Future<List<OfflineProduct>> getProducts({ProductRequest? request}) async {
    if (request?.name != null && request!.name!.isNotEmpty) {
      return await _isar.offlineProducts
          .where()
          .filter()
          .nameContains(request.name!, caseSensitive: false)
          .findAll();
    }

    if (request?.categoryId != null && request!.categoryId!.isNotEmpty) {
      return await _isar.offlineProducts
          .where()
          .filter()
          .categoryIdEqualTo(int.parse(request.categoryId!))
          .findAll();
    }

    return await _isar.offlineProducts.where().findAll();
  }

  @override
  Future<OfflineProduct?> getProductById(int id) async {
    return await _isar.offlineProducts.get(id);
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