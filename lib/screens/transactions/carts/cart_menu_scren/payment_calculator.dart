import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/calculator_payment_button.dart';

class PaymentCalculator extends StatefulWidget {
  const PaymentCalculator({
    super.key,
  });

  @override
  State<PaymentCalculator> createState() => _PaymentCalculatorState();
}

class _PaymentCalculatorState extends State<PaymentCalculator> {
  final _cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => Text(
              formatPrice(
                _cartController.cartSessions.value.payedMoney!,
                isSymbol: false,
              ),
              style: const TextStyle(
                fontSize: 47,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Center(
            child: SizedBox(
              width: Get.width * (!context.isPhone ? 30 : 100) / 100,
              child: CalculatorPaymentButton(
                onUpdated: (String value) {
                  _cartController.cartSessions.update((val) {
                    val!.payedMoney = double.parse(value);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
