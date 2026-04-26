import 'package:lakasir/api/requests/product_stock_request.dart';
import 'package:lakasir/api/responses/products/stocks/stock_response.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';
import 'package:lakasir/offline/models/offline_stock_model.dart';
import 'package:lakasir/offline/services/stock_service_interface.dart';
import 'package:lakasir/services/product_stock_service.dart' as api;

class OnlineStockService implements StockServiceInterface {
  final _isar = LakasirDatabase.isar;
  final _apiService = api.ProductStockService();

  @override
  Future<List<OfflineStock>> getStocksByProduct(int productId) async {
    try {
      final response = await _apiService.get(productId);
      if (response.data != null) {
        await _cacheStocks(response.data!, productId);
      }
    } catch (_) {
      // Silently fall back to cache on API failure
    }

    return await _getCachedStocksByProduct(productId);
  }

  @override
  Future<OfflineStock> createStock(OfflineStock stock, int productId) async {
    final request = ProductStockRequest(
      stock: stock.stock ?? 0,
      type: stock.type,
      date: stock.date,
      initialPrice: stock.initialPrice,
      sellingPrice: stock.sellingPrice,
    );

    try {
      await _apiService.create(productId, request);
      stock.isLocal = false;
    } catch (_) {
      stock.isLocal = true;
    }

    await _saveStockWithLink(stock, productId);

    return stock;
  }

  @override
  Future<OfflineStock> updateStock(OfflineStock stock) async {
    stock.isLocal = true;

    await _isar.writeTxn(() async {
      await _isar.offlineStocks.put(stock);
    });

    return stock;
  }

  Future<void> _cacheStocks(List<StockResponse> stocks, int productId) async {
    final product = await _isar.offlineProducts.get(productId);
    if (product == null) return;

    await _isar.writeTxn(() async {
      for (final s in stocks) {
        final offline = OfflineStock()
          ..id = s.id
          ..stock = s.stock
          ..initStock = s.initStock
          ..type = s.type
          ..initialPrice = s.initialPrice
          ..sellingPrice = s.sellingPrice
          ..date = s.date
          ..isLocal = false;
        await _isar.offlineStocks.put(offline);
        offline.product.value = product;
        await offline.product.save();
      }
    });
  }

  Future<List<OfflineStock>> _getCachedStocksByProduct(int productId) async {
    final product = await _isar.offlineProducts.get(productId);
    if (product == null) return [];
    await product.stocks.load();
    return product.stocks.toList();
  }

  Future<void> _saveStockWithLink(OfflineStock stock, int productId) async {
    final product = await _isar.offlineProducts.get(productId);
    if (product == null) {
      throw Exception('Product with id $productId not found');
    }

    await _isar.writeTxn(() async {
      await _isar.offlineStocks.put(stock);
      stock.product.value = product;
      await stock.product.save();
    });
  }
}