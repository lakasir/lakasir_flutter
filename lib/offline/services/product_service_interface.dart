import 'package:lakasir/api/requests/product_request.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';

abstract class ProductServiceInterface {
  Future<List<OfflineProduct>> getProducts({ProductRequest? request});
  Future<OfflineProduct?> getProductById(int id);
  Future<OfflineProduct> createProduct(OfflineProduct product);
  Future<OfflineProduct> updateProduct(OfflineProduct product);
  Future<void> deleteProduct(int id);
}