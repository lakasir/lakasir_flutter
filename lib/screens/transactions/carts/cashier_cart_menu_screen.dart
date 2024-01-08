import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/select_input_feld.dart';

class CashierCartMenuScreen extends StatefulWidget {
  const CashierCartMenuScreen({super.key});

  @override
  State<CashierCartMenuScreen> createState() => _CashierCartMenuScreenState();
}

class _CashierCartMenuScreenState extends State<CashierCartMenuScreen> {
  final _cartController = Get.put(CartController());

  SelectInputWidgetController selectInputWidgetController =
      SelectInputWidgetController();

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Cart List',
      bottomNavigationBar: MyBottomBar(
        label: const Text("Proceed to Payment"),
        onPressed: () {
          _cartController.cartSessions.update((val) {
            val!.payedMoney = _cartController.cartSessions.value.getTotalPrice;
          });
          Get.toNamed('/menu/transaction/cashier/payment');
        },
        singleAction: true,
        singleActionIcon: Icons.delete,
        singleActionOnPressed: () {
          Get.dialog(AlertDialog(
            title: const Text('Delete All Cart'),
            content: const Text('Are you sure to delete all cart?'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _cartController.cartSessions.update((val) {
                    val!.cartItems.clear();
                    val.totalPrice = 0;
                    val.totalQty = 0;
                    val.payedMoney = 0;
                  });
                  Get.back();
                  Get.back();
                },
                child: const Text('Delete'),
              ),
            ],
          ));
        },
      ),
      child: Obx(
        () {
          final cartItems = _cartController.cartSessions.value.cartItems;
          var totalPrice = _cartController.cartSessions.value.getTotalPrice;

          return ListView(
            children: [
              for (var i = 0; i < cartItems.length; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: MyCardList(
                    list: [
                      SizedBox(
                        width: Get.width * 88 / 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItems[i].product.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    cartItems[i].buildRowPrice(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: whiteGrey,
                                  ),
                                  height: 30,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      MaterialButton(
                                        minWidth: 50,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          _cartController
                                              .removeQty(cartItems[i]);
                                        },
                                        child: const Icon(
                                          Icons.remove_rounded,
                                          size: 15,
                                        ),
                                      ),
                                      Flexible(
                                        child: Center(
                                          child: Text(
                                            cartItems[i].qty.toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      MaterialButton(
                                        minWidth: 50,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          _cartController.addQty(cartItems[i]);
                                        },
                                        child: const Icon(
                                          Icons.add_rounded,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                width: double.infinity,
                height: 2,
                decoration: const BoxDecoration(
                  color: grey,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                margin: const EdgeInsets.only(top: 15, bottom: 15),
              ),
              Text(
                formatPrice(totalPrice.toDouble()),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
