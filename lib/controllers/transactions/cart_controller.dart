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

  void addCartSession(CartSession cartSession) {
    cartSessions.value = cartSession;
    Get.toNamed('/menu/transaction/cashier/cart');
  }

  void addToCart(CartItem cartItem) async {
    isAddToCartLoading(true);
    await _productDetailController.get(cartItem.product.id);
    if (_productDetailController.product.value.stock! <
        int.parse(qtyController.text)) {
      Get.rawSnackbar(
        message: 'Stock is not enough',
        backgroundColor: error,
        duration: const Duration(seconds: 2),
      );
      isAddToCartLoading(false);
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
      return;
    }
    cartSessions
        .value.cartItems[cartSessions.value.cartItems.indexOf(cartItem)].qty--;
    cartSessions.refresh();
  }

  void addQty(CartItem cartItem) {
    if (_productDetailController.product.value.stock! < cartItem.qty + 1) {
      Get.rawSnackbar(
        message: 'Stock is not enough',
        backgroundColor: error,
        duration: const Duration(seconds: 2),
      );
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

    showDialog(
      context: Get.context!,
      builder: (context) {
        return MyDialog(
          title: 'Add to Cart',
          content: Form(
            key: globalKey,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: MyTextField(
                    label: 'Qty',
                    hintText: 'Qty Name',
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
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CartSession {
  double? totalPrice;
  double? payedMoney;
  MemberResponse? member;
  int? tax;
  PaymentMethodRespone? paymentMethod;
  int? totalQty;
  final bool friendPrice;
  final List<CartItem> cartItems;

  CartSession({
    this.totalPrice,
    this.payedMoney,
    this.friendPrice = false,
    this.totalQty,
    this.member,
    this.tax,
    this.paymentMethod,
    required this.cartItems,
  });

  String get getMemberName {
    return member?.name ?? 'No Member';
  }

  String get getPaymentMethodName {
    return paymentMethod?.name ?? 'Cash';
  }

  double get getTotalPrice {
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
