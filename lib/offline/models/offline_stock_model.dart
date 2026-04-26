import 'package:isar/isar.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';

part 'offline_stock_model.g.dart';

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