import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/utils/utils.dart';

class SellingDetail {
  int id;
  int sellingId;
  int productId;
  double price;
  double discountPrice;
  int quantity;
  ProductResponse? product;

  SellingDetail({
    required this.id,
    required this.sellingId,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.discountPrice,
    this.product,
  });

  factory SellingDetail.fromJson(Map<String, dynamic> json) {
    return SellingDetail(
      id: json['id'],
      sellingId: json['selling_id'],
      productId: json['product_id'],
      price: double.parse(json['price'].toString()),
      discountPrice: double.parse(json['discount_price'].toString()),
      quantity: json['qty'],
      product: json['product'] != null
          ? ProductResponse.fromJson(json['product'])
          : null,
    );
  }
}
