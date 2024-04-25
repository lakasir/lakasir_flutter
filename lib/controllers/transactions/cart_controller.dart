import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/members/member_response.dart';
import 'package:lakasir/api/responses/payment_methods/payment_method_response.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/products/product_detail_controller.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/text_field.dart';

class CartController extends GetxController {
  Rx<CartSession> cartSessions = CartSession(
    cartItems: [],
  ).obs;
  // RxList<CartItem> cartItems = <CartItem>[].obs;
  final globalKey = GlobalKey<FormState>();
  final _productDetailController = Get.put(ProductDetailController());
  final RxBool isAddToCartLoading = false.obs;

  final qtyController = TextEditingController();

  bool isNotEnoughStock() {
    bool isNotEnoughStock = _productDetailController.product.value.stock! <
        int.parse(qtyController.text);
    if (!_productDetailController.product.value.isNonStock &&
        isNotEnoughStock) {
      Get.rawSnackbar(
        message: 'Stock is not enough',
        backgroundColor: error,
        duration: const Duration(seconds: 2),
      );
      isAddToCartLoading(false);
      return true;
    }
    return false;
  }

  void addCartSession(CartSession cartSession) {
    cartSessions.value = cartSession;
    Get.toNamed('/menu/transaction/cashier/cart');
  }

  void addToCart(CartItem cartItem) async {
    isAddToCartLoading(true);
    await _productDetailController.get(cartItem.product.id);
    if (isNotEnoughStock()) {
      return;
    }
    if (!globalKey.currentState!.validate()) {
      isAddToCartLoading(false);
      return;
    }
    if (cartSessions.value.cartItems.contains(cartItem)) {
      cartSessions
          .value
          .cartItems[cartSessions.value.cartItems.indexOf(cartItem)]
          .qty = cartItem.qty;
    } else {
      cartSessions.value.cartItems.add(cartItem);
    }
    cartSessions.refresh();
    isAddToCartLoading(false);
    Get.back();
  }

  void removeQty(CartItem cartItem) {
    if (cartItem.qty == 1) {
      cartSessions.value.cartItems.remove(cartItem);
      cartSessions.refresh();
      if (cartSessions.value.cartItems.isEmpty) {
        Get.back();
      }
      return;
    }
    cartSessions
        .value.cartItems[cartSessions.value.cartItems.indexOf(cartItem)].qty--;
    cartSessions.refresh();
  }

  void addQty(CartItem cartItem) {
    if (isNotEnoughStock()) {
      return;
    }
    cartSessions
        .value.cartItems[cartSessions.value.cartItems.indexOf(cartItem)].qty++;
    cartSessions.refresh();
  }

  void showAddToCartDialog(ProductResponse product) {
    qtyController.clear();
    qtyController.text = cartSessions.value.cartItems
        .firstWhere((element) => element.product.id == product.id,
            orElse: () => CartItem(product: product, qty: 1))
        .qty
        .toString();

    Get.dialog(MyDialog(
      title: 'cashier_add_to_cart'.tr,
      content: Form(
        key: globalKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: MyTextField(
                label: 'field_qty'.tr,
                controller: qtyController,
                mandatory: true,
                keyboardType: TextInputType.number,
              ),
            ),
            Obx(
              () => MyFilledButton(
                onPressed: () {
                  addToCart(CartItem(
                    product: product,
                    qty: int.parse(qtyController.text),
                  ));
                },
                isLoading: isAddToCartLoading.value,
                child: Text("global_save".tr),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void showDeleteCartDialog() {
    Get.dialog(AlertDialog(
      title: Text('cart_delete_all'.tr),
      content: Text('cart_delete_all_content'.tr),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('global_cancel'.tr),
        ),
        TextButton(
          onPressed: () {
            cartSessions.update((val) {
              val!.cartItems.clear();
              val.totalPrice = 0;
              val.totalQty = 0;
              val.payedMoney = 0;
            });
            Get.back();
            Get.back();
          },
          child: Text('global_delete'.tr),
        ),
      ],
    ));
  }
}

class CartSession {
  double? totalPrice;
  double? payedMoney;
  MemberResponse? member;
  int? customerNumber;
  double? tax;
  PaymentMethodRespone? paymentMethod = PaymentMethodRespone(
    id: 1,
    name: 'Cash',
  );
  int? totalQty;
  final bool friendPrice;
  final List<CartItem> cartItems;
  String? note;

  CartSession({
    this.totalPrice,
    this.payedMoney,
    this.friendPrice = false,
    this.totalQty,
    this.member,
    this.tax,
    this.paymentMethod,
    this.customerNumber,
    this.note,
    required this.cartItems,
  });

  String get getMemberName {
    return member?.name ??
        'global_no_item'.trParams({
          'item': 'menu_member'.tr,
        });
  }

  String get getPaymentMethodName {
    return paymentMethod?.name ?? 'Cash';
  }

  double get getTotalPrice {
    var tax = this.tax ?? 0;
    return cartItems.fold(
      0,
      (previousValue, element) =>
          previousValue +
          (element.qty * element.product.sellingPrice!.toInt()) *
              (1 + (tax / 100)),
    );
  }

  double get getSubTotalPrice {
    return cartItems.fold(
      0,
      (previousValue, element) =>
          previousValue + (element.qty * element.product.sellingPrice!.toInt()),
    );
  }

  int get getTotalQty {
    return cartItems.fold(
      0,
      (previousValue, element) => previousValue + element.qty,
    );
  }

  String get getCustomerNumber {
    return customerNumber == null
        ? "global_no_item".trParams({
            'item': 'field_customer_number'.tr,
          })
        : customerNumber.toString();
  }

  String get getNote {
    return note ?? 'global_no_item'.trParams({'item': 'field_note'.tr});
  }
}

class CartItem {
  ProductResponse product;
  int qty;

  CartItem({
    required this.product,
    required this.qty,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem && other.product.id == product.id;
  }

  @override
  int get hashCode => product.id.hashCode;

  String buildRowPrice() {
    return '${formatPrice(product.sellingPrice!, isSymbol: false)} x $qty = ${formatPrice(
      (product.sellingPrice! * qty).toDouble(),
    )}';
  }

  String buildSubTotalPrice() {
    return formatPrice(
      (product.sellingPrice! * qty).toDouble(),
    );
  }
}
