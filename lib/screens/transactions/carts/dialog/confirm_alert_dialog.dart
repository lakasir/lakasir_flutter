import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/controllers/transactions/payment_controller.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/filled_button.dart';

class ConfirmAlertDialog extends StatelessWidget {
  ConfirmAlertDialog({super.key});
  final _cartController = Get.put(CartController());
  final _paymentController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    final cartItems = _cartController.cartSessions.value.cartItems;
    return MyDialog(
      title: "Are you sure?",
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Member:",
              ),
              Text(
                _cartController.cartSessions.value.getMemberName,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Payment Method:",
              ),
              Text(
                _cartController.cartSessions.value.getPaymentMethodName,
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
                      cartItems[i].product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(cartItems[i].buildRowPrice()),
                  ],
                ),
                Text(cartItems[i].buildSubTotalPrice()),
              ],
            ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total:"),
              Text(
                formatPrice(
                  _cartController.cartSessions.value.getTotalPrice,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Payed Money: ",
              ),
              Text(
                formatPrice(
                  _cartController.cartSessions.value.payedMoney!,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Change: ",
              ),
              Text(
                formatPrice(
                  _cartController.cartSessions.value.payedMoney! -
                      _cartController.cartSessions.value.getTotalPrice,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: MyFilledButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Obx(
                  () => MyFilledButton(
                    isLoading: _paymentController.isLoading.value,
                    onPressed: () {
                      _paymentController.store();
                    },
                    child: const Text("Yes"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
