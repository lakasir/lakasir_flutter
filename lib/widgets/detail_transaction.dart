import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';

class DetailTransaction extends StatefulWidget {
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

  @override
  State<DetailTransaction> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTransaction> {
  final _authController = Get.put(AuthController());

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
        if (widget.cashierName != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("field_cashier".tr, style: _normalStyle),
              Text(widget.cashierName!, style: _boldStyle),
            ],
          ),
        if (widget.sellingCode != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("field_code".tr, style: _normalStyle),
              Text(widget.sellingCode!, style: _boldStyle),
            ],
          ),
        if (widget.date != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("field_date".tr, style: _normalStyle),
              Text(widget.date!, style: _boldStyle),
            ],
          ),
        if (_authController.feature(feature: 'member'))
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("field_member".tr, style: _normalStyle),
              Text(widget.memberName, style: _boldStyle),
            ],
          ),
        if (_authController.feature(feature: 'payment-method'))
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("field_payment_method".tr, style: _normalStyle),
              Text(widget.paymentMethod, style: _boldStyle),
            ],
          ),
        const Divider(),
        for (var i = 0; i < widget.cartItems.length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.cartItems[i].productName, style: _boldStyle),
                  Text(widget.cartItems[i].quantity, style: _normalStyle)
                ],
              ),
              Text(widget.cartItems[i].subTotal, style: _boldStyle)
            ],
          ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("field_tax".tr, style: _normalStyle),
            Text(widget.tax, style: _boldStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subtotal".tr, style: _normalStyle),
            Text(widget.subTotal, style: _boldStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("discount".tr, style: _normalStyle),
            Text(widget.discount, style: _boldStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("global_total".tr, style: _normalStyle),
            Text(widget.total, style: _boldStyle),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("field_payed_money".tr, style: _normalStyle),
            Text(widget.payedMoney, style: _boldStyle),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("field_change".tr, style: _normalStyle),
            Text(widget.change, style: _boldStyle)
          ],
        ),
        if (widget.note != null)
          const SizedBox(
            height: 10,
          ),
        if (widget.note != null)
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("field_note".tr, style: _normalStyle),
                Text(widget.note ?? '', style: _boldStyle)
              ],
            ),
          ),
        if (widget.actions.isNotEmpty) const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var action in widget.actions) action,
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
