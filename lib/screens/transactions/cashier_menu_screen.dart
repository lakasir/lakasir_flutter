import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/controllers/transactions/cash_drawer_controller.dart';
import 'package:lakasir/screens/transactions/carts/cart_menu_scren/cart_control_widget.dart';
import 'package:lakasir/screens/transactions/carts/dialog/edit_alert_dialog.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/build_list_image.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/text_field.dart';

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
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Layout(
            resizeToAvoidBottomInset: true,
            title: 'transaction_cashier'.tr,
            bottomNavigationBar: MyBottomBar(
              icon:
                  !context.isTablet ? Icons.shopping_basket : Icons.credit_card,
              label: Obx(
                () {
                  var subTotalPrice = formatPrice(
                    _cartController.cartSessions.value.getSubTotalPrice -
                        _cartController.cartSessions.value.getDiscountPrice,
                    isSymbol: false,
                  );
                  return Text(
                    '${_cartController.cartSessions.value.cartItems.length}'
                    ' - $subTotalPrice',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              actions: context.isTablet
                  ? [
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
                    ]
                  : null,
              onPressed: () {
                var cartSession = _cartController.cartSessions.value;

                if (_settingController.setting.value.cashDrawerEnabled) {
                  if (_cashDrawerController.isOpened.value) {
                    _cashDrawerController.showCashDrawerDialog();
                    return;
                  }
                }

                if (cartSession.cartItems.isEmpty) {
                  Get.rawSnackbar(
                    message: 'Cart is empty',
                    backgroundColor: error,
                    duration: const Duration(seconds: 2),
                  );
                  return;
                }

                _cartController.addCartSession(
                  CartSession(
                    tax: cartSession.tax,
                    member: cartSession.member,
                    paymentMethod: cartSession.paymentMethod,
                    discountPrice: cartSession.discountPrice,
                    note: cartSession.note,
                    cartItems: cartSession.cartItems,
                    totalQty: cartSession.getTotalQty,
                    totalPrice: cartSession.getTotalPrice,
                    payedMoney: cartSession.getTotalPrice,
                  ),
                  context,
                );
              },
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
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
                if (context.isTablet)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 20),
                      child: const CartControlWidget(),
                    ),
                  )
              ],
            ),
          );
        },
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
          if (_authController.feature(feature: 'product-stock'))
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
}
