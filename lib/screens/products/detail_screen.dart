import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/products/product_detail_controller.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/screens/products/product_detail_widget.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  final _productDetailController = Get.put(ProductDetailController());
  final _settingController = Get.put(SettingController());
  final AuthController _authController = Get.put(AuthController());
  ProductResponse products = ProductResponse();

  @override
  void initState() {
    setState(() {
      products = Get.arguments as ProductResponse;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Obx(
      () {
        return Layout(
          baseHeight: double.infinity,
          noAppBar: true,
          noPadding: true,
          bottomNavigationBar: MyBottomBar(
            hideBlockButton: !can(
              _authController.permissions,
              ability: 'update product',
            ),
            onPressed: () {
              Get.toNamed('/menu/product/edit', arguments: products);
            },
            actions: [
              if (!products.isNonStock &&
                  can(
                    _authController.permissions,
                    ability: 'read product stock',
                  ))
                MyBottomBarActions(
                  badge: 'field_stock'.tr,
                  onPressed: () {
                    Get.toNamed(
                      '/menu/product/stock',
                      arguments: products,
                    );
                  },
                  icon: const Icon(Icons.inventory, color: Colors.white),
                ),
              if (can(
                _authController.permissions,
                ability: 'delete product',
              ))
                MyBottomBarActions(
                  badge: 'global_delete'.tr,
                  onPressed: () {
                    _productDetailController.showDeleteDialog(
                      products.id,
                    );
                  },
                  icon: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
            ],
            label: Text('product_edit'.tr),
            icon: Icons.edit,
          ),
          child: Column(
            children: [
              Hero(
                tag: 'product-${products.id}',
                child: ClipRRect(
                  child: Image.network(
                    products.image ?? '',
                    fit: BoxFit.cover,
                    height: 300,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Image(
                        image: AssetImage('assets/no-image-100.png'),
                        fit: BoxFit.cover,
                        height: 300,
                        width: double.infinity,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: ProductDetailWidget(
                  isLoading: _productDetailController.isLoading.value,
                  width: width,
                  products: products,
                  settingController: _settingController,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
