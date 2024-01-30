import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/payment_method_controller.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/screens/transactions/carts/dialog/edit_alert_dialog.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/card.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/select_input_feld.dart';

class CashierCartMenuScreen extends StatefulWidget {
  const CashierCartMenuScreen({super.key});

  @override
  State<CashierCartMenuScreen> createState() => _CashierCartMenuScreenState();
}

class _CashierCartMenuScreenState extends State<CashierCartMenuScreen> {
  final _cartController = Get.put(CartController());
  final _settingController = Get.put(SettingController());

  SelectInputWidgetController selectInputWidgetController =
      SelectInputWidgetController();

  @override
  void initState() {
    super.initState();
    _cartController.cartSessions.value.tax =
        _settingController.setting.value.defaultTax;
  }

  @override
  void dispose() {
    _cartController.cartSessions.value.tax = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'cart_list'.tr,
      bottomNavigationBar: MyBottomBar(
        label: Text('cart_list_proceed'.tr),
        onPressed: () {
          _cartController.cartSessions.update((val) {
            val!.payedMoney = _cartController.cartSessions.value.getTotalPrice;
          });
          Get.toNamed('/menu/transaction/cashier/payment');
        },
        actions: [
          MyBottomBarActions(
            label: 'global_edit_item'.trParams(
              {"item": "cart_list".tr},
            ),
            onPressed: () {
              Get.dialog(const EditDetailAlert());
            },
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
          MyBottomBarActions(
            label: 'global_delete'.tr,
            onPressed: _cartController.showDeleteCartDialog,
            icon: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
      child: Obx(
        () {
          final cartItems = _cartController.cartSessions.value.cartItems;

          return ListView(
            children: [
              for (var i = 0; i < cartItems.length; i++)
                CartList(
                  cartItem: cartItems[i],
                  cartController: _cartController,
                ),
              SubTotalField(cartController: _cartController),
              DetailField(cartController: _cartController),
              const SizedBox(
                height: 70,
              ),
            ],
          );
        },
      ),
    );
  }
}

class DetailField extends StatelessWidget {
  DetailField({
    super.key,
    required CartController cartController,
  }) : _cartController = cartController;

  final _paymentMethodController = Get.put(PaymentMethodController());
  final CartController _cartController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyCard(
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'field_member'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _cartController.cartSessions.value.member?.name ??
                      'global_no_item'.trParams(
                        {"item": "field_member".tr},
                      ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        MyCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                margin: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: Text(
                  "field_payment_method".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Obx(
                () {
                  if (_paymentMethodController.isFetching.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      _paymentMethodController.paymentMethods.length,
                      (index) {
                        double width = Get.width;
                        return Obx(
                          () => Container(
                            width: width * 25 / 100,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _cartController
                                          .cartSessions.value.paymentMethod ==
                                      _paymentMethodController
                                          .paymentMethods[index]
                                  ? grey
                                  : whiteGrey,
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                _cartController
                                        .cartSessions.value.paymentMethod =
                                    _paymentMethodController
                                        .paymentMethods[index];
                                _cartController.cartSessions.refresh();
                              },
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  _paymentMethodController
                                      .paymentMethods[index].name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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

class CartList extends StatelessWidget {
  const CartList({
    super.key,
    required this.cartItem,
    required CartController cartController,
  }) : _cartController = cartController;

  final CartItem cartItem;
  final CartController _cartController;

  @override
  Widget build(BuildContext context) {
    return MyCard(
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
                      cartItem.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        cartItem.buildRowPrice(),
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
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              _cartController.removeQty(cartItem);
                            },
                            child: const Icon(
                              Icons.remove_rounded,
                              size: 15,
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: Text(
                                cartItem.qty.toString(),
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
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              _cartController.addQty(cartItem);
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
    );
  }
}
