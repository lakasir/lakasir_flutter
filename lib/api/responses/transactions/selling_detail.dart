import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/utils/utils.dart';

class SellingDetail {
  int id;
  int sellingId;
  int productId;
  double price;
  double discountPrice;
  double discount;
  int quantity;
  ProductResponse? product;

  SellingDetail({
    required this.id,
    required this.sellingId,
    required this.productId,
    required this.price,
    required this.quantity,
    this.discountPrice = 0,
    this.product,
    this.discount = 0,
  });

  factory SellingDetail.fromJson(Map<String, dynamic> json) {
    return SellingDetail(
      id: json['id'],
      sellingId: json['selling_id'],
      productId: json['product_id'],
      price: double.parse(json['price'].toString()),
      discount: double.parse(json['discount'].toString()),
      discountPrice: double.parse(json['discount_price'].toString()),
      quantity: json['qty'],
      product: json['product'] != null
          ? ProductResponse.fromJson(json['product'])
          : null,
    );
  }

  String buildRowPrice() {
    var priceText = "${formatPrice(price, isSymbol: false)} x $quantity";

    if (discountPrice != 0) {
      priceText =
          "($priceText) -\n${formatPrice(discountPrice, isSymbol: false)} ";
    }

    return priceText;
  }
}
