import 'package:lakasir/api/responses/products/product_response.dart';

class SellingDetail {
  int id;
  int sellingId;
  int productId;
  double price;
  int quantity;
  ProductResponse? product;

  SellingDetail({
    required this.id,
    required this.sellingId,
    required this.productId,
    required this.price,
    required this.quantity,
    this.product,
  });

  factory SellingDetail.fromJson(Map<String, dynamic> json) {
    return SellingDetail(
      id: json['id'],
      sellingId: json['selling_id'],
      productId: json['product_id'],
      price: double.parse(json['price'].toString()),
      quantity: json['qty'],
      product: json['product'] != null
          ? ProductResponse.fromJson(json['product'])
          : null,
    );
  }
}
