import 'package:isar/isar.dart';
import 'package:lakasir/api/requests/product_request.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';
import 'package:lakasir/offline/services/product_service_interface.dart';
import 'package:lakasir/services/product_service.dart' as api;

class OnlineProductService implements ProductServiceInterface {
  final _isar = LakasirDatabase.isar;
  final _apiService = api.ProductService();

  @override
  Future<List<OfflineProduct>> getProducts({ProductRequest? request}) async {
    try {
      final response = await _apiService.get(request);
      if (response.data != null) {
        await _cacheProducts(response.data!);
      }
    } catch (_) {
      // Silently fall back to cache on API failure
    }

    return await _getCachedProducts(request: request);
  }

  @override
  Future<OfflineProduct?> getProductById(int id) async {
    return await _isar.offlineProducts.get(id);
  }

  @override
  Future<OfflineProduct> createProduct(OfflineProduct product) async {
    final request = ProductRequest(
      name: product.name,
      categoryId: product.categoryId?.toString(),
      stock: product.stock?.toDouble(),
      initialPrice: product.initialPrice,
      sellingPrice: product.sellingPrice,
      type: product.type,
      unit: product.unit,
      photoUrl: product.image,
      isNonStock: product.isNonStock,
      sku: product.sku,
      barcode: product.barcode,
    );

    try {
      await _apiService.create(request);
      product.isLocal = false;
    } catch (_) {
      product
        ..isLocal = true
        ..cachedAt = DateTime.now();
    }

    await _isar.writeTxn(() async {
      await _isar.offlineProducts.put(product);
    });

    return product;
  }

  @override
  Future<OfflineProduct> updateProduct(OfflineProduct product) async {
    final request = ProductRequest(
      name: product.name,
      categoryId: product.categoryId?.toString(),
      stock: product.stock?.toDouble(),
      initialPrice: product.initialPrice,
      sellingPrice: product.sellingPrice,
      type: product.type,
      unit: product.unit,
      photoUrl: product.image,
      isNonStock: product.isNonStock,
      sku: product.sku,
      barcode: product.barcode,
    );

    try {
      await _apiService.update(product.id, request);
      product.isLocal = false;
    } catch (_) {
      product
        ..isLocal = true
        ..cachedAt = DateTime.now();
    }

    await _isar.writeTxn(() async {
      await _isar.offlineProducts.put(product);
    });

    return product;
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await _apiService.delete(id);
    } catch (_) {
      // Ignore API failure, delete locally regardless
    }

    await _isar.writeTxn(() async {
      await _isar.offlineProducts.delete(id);
    });
  }

  Future<void> _cacheProducts(List<ProductResponse> products) async {
    final cached = products.map((p) {
      return OfflineProduct()
        ..id = p.id
        ..name = p.name
        ..type = p.type
        ..unit = p.unit
        ..image = p.image
        ..initialPrice = p.initialPrice
        ..sellingPrice = p.sellingPrice
        ..discount = p.discount
        ..discountPrice = p.discountPrice
        ..stock = p.stock
        ..categoryId = p.categoryId
        ..categoryName = p.category?.name ?? ''
        ..sku = p.sku
        ..barcode = p.barcode
        ..isNonStock = p.isNonStock
        ..cachedAt = DateTime.now()
        ..isLocal = false;
    }).toList();

    await _isar.writeTxn(() async {
      await _isar.offlineProducts.putAll(cached);
    });
  }

  Future<List<OfflineProduct>> _getCachedProducts({
    ProductRequest? request,
  }) async {
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
}