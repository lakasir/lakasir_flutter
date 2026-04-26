import 'package:isar/isar.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';

part 'cart_model.g.dart';

@collection
class OfflineCart {
  Id id = Isar.autoIncrement;

  int productId = 0;
  int quantity = 1;
  double price = 0;
  double discountPrice = 0;
  DateTime addedAt = DateTime.now();

  @ignore
  OfflineProduct? product;

  OfflineCart();
}