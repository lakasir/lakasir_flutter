class PaymentRequest {
  double? payedMoney;
  bool? friendPrice;
  int? memberId;
  int? tax;
  List<PaymentRequestItem>? products;

  PaymentRequest({
    this.payedMoney,
    this.friendPrice,
    this.products,
    this.memberId,
    this.tax,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['payed_money'] = payedMoney;
    data['friend_price'] = friendPrice;
    if (memberId != null) data['member_id'] = memberId;
    if (tax != null) data['tax'] = tax;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentRequestItem {
  int? productId;
  int? qty;

  PaymentRequestItem({this.productId, this.qty});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['qty'] = qty;
    return data;
  }
}
