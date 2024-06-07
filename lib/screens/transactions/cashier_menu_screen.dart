import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/controllers/transactions/cash_drawer_controller.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/build_list_image.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/text_field.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class CashierMenuScreen extends StatefulWidget {
  const CashierMenuScreen({super.key});

  @override
  State<CashierMenuScreen> createState() => _CashierMenuScreenState();
}

class _CashierMenuScreenState extends State<CashierMenuScreen> {
  final _productController = Get.put(ProductController());
  final _cartController = Get.put(CartController());
  final _settingController = Get.put(SettingController());
  final _cashDrawerController = Get.put(CashDrawerController());
  final _authController = Get.put(AuthController());
  bool showCashDrawer = false;
  final Duration initialDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    Timer(initialDuration, () {
      if (_settingController.setting.value.cashDrawerEnabled) {
        if (!_cashDrawerController.isOpened.value) return;
        _cashDrawerController.showCashDrawerDialog();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (isPop) {
        _productController.searchByNameController.clear();
        _productController.getProducts();
      },
      child: Layout(
        title: 'transaction_cashier'.tr,
        bottomNavigationBar: MyBottomBar(
          singleAction: can(_authController.permissions, 'open cash drawer'),
          singleActionIcon: Icons.edit_note,
          singleActionOnPressed: () {
            if (!_settingController.setting.value.cashDrawerEnabled) {
              Get.dialog(AlertDialog(
                title: Text('cashier_set_cash_drawer'.tr),
                content: Text('cashier_set_cash_drawer_enabled_info'.tr),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('global_no'.tr),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed('/menu/setting');
                    },
                    child: Text('global_yes'.tr),
                  ),
                ],
              ));
              return;
            }
            openSunmiCashDrawer();
            _cashDrawerController.showCashDrawerDialog();
          },
          label: Obx(
            () => Row(
              children: [
                if (_cartController.cartSessions.value.cartItems.isEmpty)
                  const Icon(Icons.shopping_cart_rounded, color: Colors.white),
                if (_cartController.cartSessions.value.cartItems.isNotEmpty)
                  Text(
                    '${_cartController.cartSessions.value.cartItems.length} Items'
                    ' - ${formatPrice(_cartController.cartSessions.value.getSubTotalPrice)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          onPressed: () {
            if (_settingController.setting.value.cashDrawerEnabled) {
              if (_cashDrawerController.isOpened.value) {
                _cashDrawerController.showCashDrawerDialog();
                return;
              }
            }
            if (_cartController.cartSessions.value.cartItems.isEmpty) {
              Get.rawSnackbar(
                message: 'Cart is empty',
                backgroundColor: error,
                duration: const Duration(seconds: 2),
              );
              return;
            }
            _cartController.addCartSession(
              CartSession(
                cartItems: _cartController.cartSessions.value.cartItems,
                totalQty: _cartController.cartSessions.value.getTotalQty,
                totalPrice: _cartController.cartSessions.value.getTotalPrice,
                payedMoney: _cartController.cartSessions.value.getTotalPrice,
              ),
            );
          },
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10, top: 10),
              child: MyTextField(
                key: const ValueKey('search'),
                controller: _productController.searchByNameController,
                hintText: 'cashier_search_trigger'.tr,
                onChanged: (value) {
                  if (value.length >= 3) {
                    _productController.searchProduct();
                  }

                  if (value.isEmpty) {
                    _productController.getProducts();
                  }
                },
                textInputAction: TextInputAction.search,
                rightIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      color: primary,
                      onPressed: () {
                        _productController.searchProduct();
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () {
                  if (_productController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (_productController.products.isEmpty) {
                    return Center(
                      child: Text('global_no_item'.trParams(
                        {'item': 'menu_product'.tr},
                      )),
                    );
                  }
                  return ListView(
                    children: [
                      for (var product in _productController.products)
                        buildMyCardList(product, _cartController),
                      const SizedBox(height: 80),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMyCardList(
    ProductResponse product,
    CartController cartController,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: MyCardList(
        onTap: () {
          cartController.showAddToCartDialog(product);
        },
        key: ValueKey(product.id),
        list: [
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            product.isNonStock
                ? 'field_is_non_stock'.tr
                : "stock: ${product.stock}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w200,
              color: product.isNonStock ? Colors.red : Colors.black,
            ),
          ),
          SizedBox(
            width: 220,
            child: Text(
              formatPrice(product.sellingPrice!),
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
        imagebox: BuildListImage(url: product.image),
      ),
    );
  }

  void openSunmiCashDrawer() async {
    try {
      await SunmiPrinter.bindingPrinter();
      await SunmiPrinter.openDrawer();
      print('Sunmi cash drawer opened successfully');
    } catch (e) {
      print('Error opening Sunmi cash drawer: $e');
    }
  }
}
