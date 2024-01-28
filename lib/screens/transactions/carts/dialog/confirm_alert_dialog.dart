import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/controllers/transactions/payment_controller.dart';
import 'package:lakasir/utils/colors.dart';
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
      title: "global_sure?".tr,
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "field_member".tr,
              ),
              Text(
                _cartController.cartSessions.value.getMemberName,
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
              Text("field_tax".tr),
              Text(
                "${_cartController.cartSessions.value.tax!}" "%",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal".tr),
              Text(
                formatPrice(
                  _cartController.cartSessions.value.getSubTotalPrice,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("global_total".tr),
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
              Text(
                "field_payed_money".tr,
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
              Text(
                "field_change".tr,
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
                  color: grey,
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("global_cancel".tr),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Obx(
                  () => MyFilledButton(
                    isLoading: _paymentController.isLoading.value,
                    onPressed: () {
                      _paymentController.store();
                    },
                    child: Text("global_yes".tr),
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
