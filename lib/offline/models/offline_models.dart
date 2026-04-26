import 'package:isar/isar.dart';

part 'offline_models.g.dart';

@collection
class OfflineCategory {
  Id id = Isar.autoIncrement;

  String name = '';
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? cachedAt;
  bool isLocal = false;

  OfflineCategory();
}

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

@collection
class OfflineStock {
  Id id = Isar.autoIncrement;

  int? stock;
  int? initStock;
  String type = 'in';
  double? initialPrice;
  double? sellingPrice;
  String date = '';
  bool isLocal = false;

  final product = IsarLink<OfflineProduct>();

  OfflineStock();
}