import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';
import 'package:lakasir/offline/models/offline_stock_model.dart';
import 'package:lakasir/offline/services/stock_service_interface.dart';

class OfflineStockService implements StockServiceInterface {
  final _isar = LakasirDatabase.isar;

  @override
  Future<List<OfflineStock>> getStocksByProduct(int productId) async {
    final product = await _isar.offlineProducts.get(productId);
    if (product == null) return [];
    await product.stocks.load();
    return product.stocks.toList();
  }

  @override
  Future<OfflineStock> createStock(OfflineStock stock, int productId) async {
    final product = await _isar.offlineProducts.get(productId);
    if (product == null) {
      throw Exception('Product with id $productId not found');
    }

    final count = await _isar.offlineStocks.count();
    stock
      ..id = -(count + 1)
      ..isLocal = true;

    await _isar.writeTxn(() async {
      await _isar.offlineStocks.put(stock);
      stock.product.value = product;
      await stock.product.save();
    });

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
}