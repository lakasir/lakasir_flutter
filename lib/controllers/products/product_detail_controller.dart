import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/categories/category_response.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/services/product_service.dart';
import 'package:lakasir/utils/colors.dart';

class ProductDetailController extends GetxController {
  final _productService = ProductService();
  final ProductController _productController = Get.find();
  final RxBool isLoading = false.obs;
  final Rx<ProductResponse> product = ProductResponse().obs;

  Future<void> delete(int id) async {
    await _productService.delete(id);
  }

  Future<void> get(int id) async {
    isLoading(true);
    final response = await _productService.getById(id);
    product.value = response;
    isLoading(false);
  }

  void showDeleteDialog(int id) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('global_sure?'.tr),
        content: Text('global_sure_content'.trParams({"item": "product"})),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('global_cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              await delete(id);
              _productController.getProducts();
              Get.back();
              Get.back();
              Get.rawSnackbar(
                message:
                    'global_deleted_item'.trParams({"item": "menu_product".tr}),
                duration: const Duration(seconds: 2),
                backgroundColor: success,
              );
            },
            child: Text('global_delete'.tr),
          ),
        ],
      ),
    );
  }
}
