import 'package:lakasir/utils/utils.dart';

class ProductRequest {
  String? name;
  String? categoryId;
  double? stock;
  double? initialPrice;
  double? sellingPrice;
  String? type;
  String? unit;
  int? heroImagesUploadedFileId;
  bool isNonStock;
  String? sku;
  String? barcode;
  String? expired;

  ProductRequest({
    this.name,
    this.categoryId,
    this.stock,
    this.initialPrice,
    this.sellingPrice,
    this.type,
    this.unit,
    this.heroImagesUploadedFileId,
    this.isNonStock = false,
    this.sku,
    this.barcode,
    this.expired,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
      'category': categoryId,
      'stock': stock,
      'initial_price': initialPrice,
      'selling_price': sellingPrice,
      'type': type ?? '',
      'unit': unit ?? '',
      'is_non_stock': isNonStock,
      'sku': sku,
      'barcode': barcode ?? '',
    };
    if (heroImagesUploadedFileId != null) {
      data['hero_images_uploaded_file_id'] = heroImagesUploadedFileId;
    }
    if (expired != null && expired!.isNotEmpty) {
      data['expired'] = expired;
    }

    return data;
  }

  String? toQuery() {
    final query = <String>[];
    if (name != null) {
      query.add('filter[global]=$name');
    }
    if (categoryId != null) {
      query.add('filter[category_id]=$categoryId');
    }
    if (type != null) {
      query.add('filter[type]=$type');
    }
    if (unit != null) {
      query.add('filter[unit]=$unit');
    }
    if (stock != null) {
      query.add('filter[stock-gt]=$stock');
    }
    return query.join('&');
  }
}
