import 'package:isar/isar.dart';
import 'package:lakasir/offline/models/offline_stock_model.dart';

part 'offline_product_model.g.dart';

@collection
class OfflineProduct {
  Id id = Isar.autoIncrement;

  String name = '';
  String type = 'product';
  String unit = '';
  String? image;
  double? initialPrice;
  double? sellingPrice;
  double? discount;
  double? discountPrice;
  int? stock;
  int? categoryId;
  String sku = '';
  String? barcode;
  bool isNonStock = false;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? cachedAt;
  bool isLocal = false;

  @Backlink(to: 'product')
  final stocks = IsarLinks<OfflineStock>();

  OfflineProduct();
}