import 'package:lakasir/api/responses/members/member_response.dart';
import 'package:lakasir/api/responses/products/product_response.dart';

class TransactionHistoryResponse {
  int id;
  String date;
  String items;
  double total;
  double moneyBack;
  double moneyPaid;
  MemberResponse? member;
  int productId;
  List<ProductResponse>? products;
  final String createdAt;
  final String updatedAt;

  TransactionHistoryResponse({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.moneyBack,
    required this.moneyPaid,
    required this.productId,
    this.member,
    this.products,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponse(
      id: json['id'],
      date: json['date'],
      items: json['items'],
      productId: json['product_id'],
      moneyBack: json['money_back'],
      moneyPaid: json['money_paid'],
      products: json['products'] != null
          ? (json['products'] as List)
              .map((e) => ProductResponse.fromJson(e))
              .toList()
          : null,
      total: json['total'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
