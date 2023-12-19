import 'package:lakasir/api/responses/products/product_response.dart';

class CartResponse {
  int id;
  int quantity;
  int productId;
  ProductResponse product;
  final String createdAt;
  final String updatedAt;

  CartResponse({
    required this.id,
    required this.quantity,
    required this.productId,
    required this.product,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      id: json['id'],
      quantity: json['quantity'],
      productId: json['product_id'],
      product: ProductResponse.fromJson(json['product']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

