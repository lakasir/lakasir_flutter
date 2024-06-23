import 'package:lakasir/api/responses/auths/profile_response.dart';
import 'package:lakasir/api/responses/members/member_response.dart';
import 'package:lakasir/api/responses/payment_methods/payment_method_response.dart';
import 'package:lakasir/api/responses/transactions/selling_detail.dart';
import 'package:lakasir/utils/utils.dart';

class TransactionHistoryResponse {
  int id;
  int? memberId;
  int? userId;
  ProfileResponse? cashier;
  String? date;
  String? code;
  double? payedMoney;
  double? moneyChange;
  double? totalPrice;
  double discount;
  double? discountPrice;
  double? totalDiscountPerItem;
  double? totalDiscount;
  double? grandTotalPrice;
  bool friendPrice;
  int paymentMethodId;
  double? tax;
  double? taxPrice;
  int? totalQuantity;
  MemberResponse? member;
  PaymentMethodRespone? paymentMethod;
  List<SellingDetail>? sellingDetails;
  String? createdAt;
  String? updatedAt;
  int? customerNumber;
  String? note;

  TransactionHistoryResponse({
    required this.id,
    this.memberId,
    this.userId,
    this.cashier,
    this.date,
    this.code,
    this.payedMoney,
    this.moneyChange,
    this.totalPrice,
    this.discount = 0,
    this.discountPrice = 0,
    this.totalDiscount = 0,
    this.totalDiscountPerItem = 0,
    this.grandTotalPrice = 0,
    required this.friendPrice,
    required this.paymentMethodId,
    this.tax = 0,
    this.taxPrice = 0,
    this.totalQuantity,
    this.member,
    this.paymentMethod,
    this.sellingDetails,
    this.createdAt,
    this.updatedAt,
    this.customerNumber,
    this.note,
  });

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponse(
      id: json['id'],
      memberId: json['member_id'],
      userId: json['user_id'],
      cashier: json['cashier'] != null
          ? ProfileResponse.fromJson(json['cashier'])
          : null,
      date: json['date'],
      code: json['code'],
      payedMoney: double.parse(json['payed_money'].toString()),
      moneyChange: double.parse(json['money_changes'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      discount: double.parse(json['discount'].toString()),
      discountPrice: double.parse(json['discount_price'].toString()),
      totalDiscountPerItem:
          double.parse(json['total_discount_per_item'].toString()),
      totalDiscount: double.parse(json['total_discount'].toString()),
      grandTotalPrice: double.parse(json['grand_total_price'].toString()),
      friendPrice: bool.fromEnvironment(json['friend_price'].toString()),
      paymentMethodId: json['payment_method_id'],
      tax: double.parse(json['tax'].toString()),
      taxPrice: double.parse(json['tax_price'].toString()),
      totalQuantity: json['total_qty'],
      member: json['member'] != null
          ? MemberResponse.fromJson(json['member'])
          : null,
      paymentMethod: json['payment_method'] != null
          ? PaymentMethodRespone.fromJson(json['payment_method'])
          : null,
      sellingDetails: json['selling_details'] != null
          ? (json['selling_details'] as List)
              .map((e) => SellingDetail.fromJson(e))
              .toList()
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      customerNumber: json['customer_number'],
      note: json['note'],
    );
  }
}
