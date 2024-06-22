import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/screens/transactions/carts/cart_menu_scren/payment_calculator.dart';
import 'package:lakasir/screens/transactions/carts/dialog/confirm_alert_dialog.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    var cartSession = _cartController.cartSessions.value;
    var subTotalPrice = cartSession.getTotalPrice;

    return Layout(
      title: "Total: ${formatPrice(subTotalPrice)}",
      bottomNavigationBar: MyBottomBar(
        onPressed: () {
          if (cartSession.payedMoney! < subTotalPrice) {
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
        label: Text(
          "Pay it".tr,
        ),
        icon: Icons.check,
      ),
      child: const PaymentCalculator(),
    );
  }
}
