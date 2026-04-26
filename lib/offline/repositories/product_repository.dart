import 'package:get/get.dart';
import 'package:lakasir/api/requests/product_request.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/offline/services/offline_product_service.dart';
import 'package:lakasir/offline/services/online_product_service.dart';
import 'package:lakasir/offline/services/product_service_interface.dart';

class ProductRepository implements ProductServiceInterface {
  late final OfflineProductService _offlineService = OfflineProductService();
  late final OnlineProductService _onlineService = OnlineProductService();

  ProductServiceInterface get _service =>
      Get.find<AppModeService>().isOnline ? _onlineService : _offlineService;

  @override
  Future<List<OfflineProduct>> getProducts({ProductRequest? request}) {
    return _service.getProducts(request: request);
  }

  @override
  Future<OfflineProduct?> getProductById(int id) {
    return _service.getProductById(id);
  }

  @override
  Future<OfflineProduct> createProduct(OfflineProduct product) {
    return _service.createProduct(product);
  }

  @override
  Future<OfflineProduct> updateProduct(OfflineProduct product) {
    return _service.updateProduct(product);
  }

  @override
  Future<void> deleteProduct(int id) {
    return _service.deleteProduct(id);
  }
}