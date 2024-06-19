class PaymentRequest {
  double? payedMoney;
  double discountPrice;
  bool? friendPrice;
  int? memberId;
  double? tax;
  List<PaymentRequestItem>? products;
  String? note;

  PaymentRequest({
    this.payedMoney,
    this.friendPrice,
    this.products,
    this.memberId,
    this.tax,
    this.note,
    this.discountPrice = 0,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['payed_money'] = payedMoney;
    data['friend_price'] = friendPrice;
    data['note'] = note;
    data['discount_price'] = discountPrice;
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
  double discountPrice;

  PaymentRequestItem({
    this.productId,
    this.qty,
    this.discountPrice = 0,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['discount_price'] = discountPrice;
    data['qty'] = qty;
    return data;
  }
}
