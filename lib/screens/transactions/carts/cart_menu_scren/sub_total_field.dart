import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/card.dart';

class SubTotalField extends StatelessWidget {
  const SubTotalField({
    super.key,
    required this.cartController,
  });
  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    var totalPrice = cartController.cartSessions.value.getTotalPrice;
    var subTotalPrice = cartController.cartSessions.value.getSubTotalPrice;
    var discountPrice = cartController.cartSessions.value.getDiscountPrice;

    return MyCard(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subtotal".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  formatPrice(subTotalPrice.toDouble()),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "discount".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "(${formatPrice(discountPrice.toDouble())})",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "field_tax".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              Text(
                "${cartController.cartSessions.value.tax ?? 0}%",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                formatPrice(totalPrice.toDouble()),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
