import 'package:lakasir/offline/models/offline_stock_model.dart';

abstract class StockServiceInterface {
  Future<List<OfflineStock>> getStocksByProduct(int productId);
  Future<OfflineStock> createStock(OfflineStock stock, int productId);
  Future<OfflineStock> updateStock(OfflineStock stock);
}