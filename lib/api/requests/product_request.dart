import 'package:lakasir/utils/utils.dart';

class ProductRequest {
  String? name;
  String? categoryId;
  double? stock;
  double? initialPrice;
  double? sellingPrice;
  String? type;
  String? unit;
  String? photoUrl;
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
    this.photoUrl,
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
      'expired': expired ?? ''
    };
    if (photoUrl != '') {
      data['hero_images_url'] = photoUrl;
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
