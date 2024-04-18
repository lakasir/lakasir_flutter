import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/screens/transactions/carts/dialog/confirm_alert_dialog.dart';

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
  });
  final String memberName;
  final String paymentMethod;
  final String customerNumber;
  final List<DetailTransactionItem> cartItems;
  final String tax;
  final String subTotal;
  final String total;
  final String payedMoney;
  final String change;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "field_member".tr,
            ),
            Text(
              memberName,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "field_payment_method".tr,
            ),
            Text(
              paymentMethod,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "field_customer_number".tr,
            ),
            Text(
              customerNumber,
            ),
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
                  Text(
                    cartItems[i].productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(cartItems[i].quantity)
                ],
              ),
              Text(cartItems[i].subTotal),
            ],
          ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("field_tax".tr),
            Text(
              tax,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subtotal".tr),
            Text(
              subTotal,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("global_total".tr),
            Text(
              total,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "field_payed_money".tr,
            ),
            Text(
              payedMoney,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "field_change".tr,
            ),
            Text(
              change,
            ),
          ],
        ),
        const Divider(),
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
