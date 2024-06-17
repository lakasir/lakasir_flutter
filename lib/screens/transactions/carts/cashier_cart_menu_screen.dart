import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/screens/transactions/carts/cart_menu_scren/cart_list.dart';
import 'package:lakasir/screens/transactions/carts/cart_menu_scren/detail_field.dart';
import 'package:lakasir/screens/transactions/carts/cart_menu_scren/payment_calculator.dart';
import 'package:lakasir/screens/transactions/carts/cart_menu_scren/sub_total_field.dart';
import 'package:lakasir/screens/transactions/carts/dialog/confirm_alert_dialog.dart';
import 'package:lakasir/screens/transactions/carts/dialog/edit_alert_dialog.dart';
import 'package:lakasir/screens/transactions/carts/payment_screen.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool isTablet = constraints.maxWidth > 600;
        CartSession cartSession = _cartController.cartSessions.value;

        return Layout(
          title: 'cart_list'.tr,
          bottomNavigationBar: MyBottomBar(
            onPressed: () {
              if (isTablet) {
                if (cartSession.payedMoney! <
                    (cartSession.getTotalPrice -
                        _cartController.cartSessions.value.getDiscountPrice)) {
                  Get.rawSnackbar(
                    message: 'Payed money is not enough',
                    backgroundColor: error,
                    duration: const Duration(seconds: 2),
                  );
                  return;
                }
                openSunmiCashDrawer();
                Get.dialog(ConfirmAlertDialog());
              } else {
                _cartController.cartSessions.update((val) {
                  val!.payedMoney =
                      _cartController.cartSessions.value.getTotalPrice;
                });

                Get.toNamed('/menu/transaction/cashier/payment');
              }
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
            child: Text('cart_list_proceed'.tr),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Obx(
                  () {
                    final cartItems =
                        _cartController.cartSessions.value.cartItems;

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
              ),
              if (isTablet)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const PaymentCalculator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
