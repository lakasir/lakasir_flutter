import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/controllers/transactions/payment_controller.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/detail_transaction.dart';
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
      content: DetailTransaction(
        memberName: _cartController.cartSessions.value.getMemberName,
        paymentMethod: _cartController.cartSessions.value.getPaymentMethodName,
        customerNumber: _cartController.cartSessions.value.getCustomerNumber,
        cartItems: cartItems
            .map(
              (e) => DetailTransactionItem(
                productName: e.product.name,
                quantity: e.buildRowPrice(),
                subTotal: e.buildSubTotalPrice(),
                discountPrice: e.buildDiscountPerItem(),
              ),
            )
            .toList(),
        tax: "${_cartController.cartSessions.value.tax ?? 0}%",
        subTotal: formatPrice(
          _cartController.cartSessions.value.getSubTotalPrice,
        ),
        total: formatPrice(
          _cartController.cartSessions.value.getTotalPrice,
        ),
        payedMoney: formatPrice(
          _cartController.cartSessions.value.payedMoney!,
        ),
        change: formatPrice(
          _cartController.cartSessions.value.payedMoney! -
              _cartController.cartSessions.value.getTotalPrice,
        ),
        note: _cartController.cartSessions.value.note,
        discount:
            formatPrice(_cartController.cartSessions.value.getDiscountPrice),
        actions: [
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
    );
  }
}
