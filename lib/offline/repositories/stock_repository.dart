import 'package:get/get.dart';
import 'package:lakasir/offline/models/offline_stock_model.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/offline/services/offline_stock_service.dart';
import 'package:lakasir/offline/services/online_stock_service.dart';
import 'package:lakasir/offline/services/stock_service_interface.dart';

class StockRepository implements StockServiceInterface {
  late final OfflineStockService _offlineService = OfflineStockService();
  late final OnlineStockService _onlineService = OnlineStockService();

  StockServiceInterface get _service =>
      Get.find<AppModeService>().isOnline ? _onlineService : _offlineService;

  @override
  Future<List<OfflineStock>> getStocksByProduct(int productId) {
    return _service.getStocksByProduct(productId);
  }

  @override
  Future<OfflineStock> createStock(OfflineStock stock, int productId) {
    return _service.createStock(stock, productId);
  }

  @override
  Future<OfflineStock> updateStock(OfflineStock stock) {
    return _service.updateStock(stock);
  }
}