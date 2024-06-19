import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/screens/transactions/carts/cart_menu_scren/cart_list.dart';
import 'package:lakasir/screens/transactions/carts/cart_menu_scren/detail_field.dart';
import 'package:lakasir/screens/transactions/carts/cart_menu_scren/sub_total_field.dart';

class CartControlWidget extends StatefulWidget {
  const CartControlWidget({
    super.key,
  });

  @override
  State<CartControlWidget> createState() => _CartControlWidgetState();
}

class _CartControlWidgetState extends State<CartControlWidget> {
  final _cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final cartItems = _cartController.cartSessions.value.cartItems;

        return ListView(
          children: [
            for (var i = 0; i < cartItems.length; i++)
              CartList(
                cartItem: cartItems[i],
              ),
            SubTotalField(cartController: _cartController),
            DetailField(cartController: _cartController),
            const SizedBox(
              height: 70,
            ),
          ],
        );
      },
    );
  }
}
