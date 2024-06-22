import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/screens/transactions/carts/cart_menu_scren/cart_control_widget.dart';
import 'package:lakasir/screens/transactions/carts/dialog/edit_alert_dialog.dart';
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
        return Layout(
          title: 'cart_list'.tr,
          bottomNavigationBar: MyBottomBar(
            onPressed: () {
              _cartController.cartSessions.update((val) {
                val!.payedMoney =
                    _cartController.cartSessions.value.getTotalPrice;
              });

              Get.toNamed('/menu/transaction/cashier/payment');
            },
            actions: [
              MyBottomBarActions(
                badge: 'global_edit_item'.trParams(
                  {"item": "cart_list".tr},
                ),
                onPressed: () {
                  Get.dialog(const EditDetailAlert());
                },
                icon: const Icon(Icons.edit, color: Colors.white),
              ),
              MyBottomBarActions(
                badge: 'global_delete'.tr,
                onPressed: () => _cartController.showDeleteCartDialog(
                  context.isTablet,
                ),
                icon: const Icon(Icons.delete, color: Colors.white),
              ),
            ],
            label: Text('cart_list_proceed'.tr),
            icon: Icons.payments,
          ),
          child: const CartControlWidget(),
        );
      },
    );
  }
}
