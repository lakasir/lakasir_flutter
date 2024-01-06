import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/text_field.dart';

class CashierMenuScreen extends StatelessWidget {
  CashierMenuScreen({super.key});

  final _productController = Get.put(ProductController());

  final _cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (isPop) {
        _productController.searchByNameController.clear();
        _productController.getProducts();
      },
      child: Layout(
        title: 'Cashier',
        bottomNavigationBar: MyBottomBar(
          label: Row(
            children: [
              const Icon(Icons.shopping_cart_rounded, color: Colors.white),
              Obx(
                () => Text(
                  _cartController.cartSessions.value.cartItems.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
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
                hintText: 'Type min 3 character to trigger search',
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
                        _productController.showFilterDialog();
                      },
                      icon: const Icon(Icons.filter_list),
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
                    return const Center(
                      child: Text('No Product'),
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
            "stock: ${product.stock}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w200,
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
        imagebox: SizedBox(
          height: 90,
          width: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              width: 200,
              height: 150,
              image: NetworkImage(product.image!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
