import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/screens/transactions/carts/cart_menu_scren/payment_calculator.dart';
import 'package:lakasir/screens/transactions/carts/dialog/confirm_alert_dialog.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/calculator_payment_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Layout(
      title:
          "Total: ${formatPrice(_cartController.cartSessions.value.getTotalPrice)}",
      bottomNavigationBar: MyBottomBar(
        onPressed: () {
          if (_cartController.cartSessions.value.payedMoney! <
              _cartController.cartSessions.value.getTotalPrice) {
            Get.rawSnackbar(
              message: 'Payed money is not enough',
              backgroundColor: error,
              duration: const Duration(seconds: 2),
            );
            return;
          }
          openSunmiCashDrawer();
          Get.dialog(ConfirmAlertDialog());
        },
        child: Text(
          "Pay it".tr,
        ),
      ),
      child: const PaymentCalculator(),
    );
  }
}
