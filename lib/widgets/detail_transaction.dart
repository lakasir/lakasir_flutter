import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailTransaction extends StatelessWidget {
  const DetailTransaction({
    super.key,
    required this.memberName,
    required this.paymentMethod,
    required this.customerNumber,
    required this.cartItems,
    required this.tax,
    required this.subTotal,
    required this.total,
    required this.payedMoney,
    required this.change,
    required this.actions,
    this.date,
    this.sellingCode,
    this.cashierName,
    this.note,
    this.discount = "0",
  });
  final String? cashierName;
  final String? date;
  final String? sellingCode;
  final String memberName;
  final String paymentMethod;
  final String customerNumber;
  final List<DetailTransactionItem> cartItems;
  final String tax;
  final String subTotal;
  final String total;
  final String payedMoney;
  final String change;
  final String? note;
  final String discount;
  final List<Widget> actions;

  TextStyle get _boldStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      );

  TextStyle get _normalStyle => const TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.black,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (cashierName != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("field_cashier".tr, style: _normalStyle),
              Text(cashierName!, style: _boldStyle),
            ],
          ),
        if (sellingCode != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("field_code".tr, style: _normalStyle),
              Text(sellingCode!, style: _boldStyle),
            ],
          ),
        if (date != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("field_date".tr, style: _normalStyle),
              Text(date!, style: _boldStyle),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("field_member".tr, style: _normalStyle),
            Text(memberName, style: _boldStyle),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("field_payment_method".tr, style: _normalStyle),
            Text(paymentMethod, style: _boldStyle),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("field_customer_number".tr, style: _normalStyle),
            Text(customerNumber, style: _boldStyle),
          ],
        ),
        const Divider(),
        for (var i = 0; i < cartItems.length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItems[i].productName, style: _boldStyle),
                  Text(cartItems[i].quantity, style: _normalStyle)
                ],
              ),
              Text(cartItems[i].subTotal, style: _boldStyle)
            ],
          ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("field_tax".tr, style: _normalStyle),
            Text(tax, style: _boldStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subtotal".tr, style: _normalStyle),
            Text(subTotal, style: _boldStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("discount".tr, style: _normalStyle),
            Text(discount, style: _boldStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("global_total".tr, style: _normalStyle),
            Text(total, style: _boldStyle),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("field_payed_money".tr, style: _normalStyle),
            Text(payedMoney, style: _boldStyle),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("field_change".tr, style: _normalStyle),
            Text(change, style: _boldStyle)
          ],
        ),
        if (note != null)
          const SizedBox(
            height: 10,
          ),
        if (note != null)
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("field_note".tr, style: _normalStyle),
                Text(note ?? '', style: _boldStyle)
              ],
            ),
          ),
        if (actions.isNotEmpty) const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var action in actions) action,
          ],
        ),
      ],
    );
  }
}

class DetailTransactionItem {
  const DetailTransactionItem({
    required this.productName,
    required this.quantity,
    required this.subTotal,
    required this.discountPrice,
  });

  final String productName;
  final String quantity;
  final String subTotal;
  final String discountPrice;
}
