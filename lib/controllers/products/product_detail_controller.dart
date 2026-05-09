import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/services/product_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';

class ProductDetailController extends GetxController {
  final _productService = ProductService();
  final ProductController _productController = Get.put(ProductController());
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
              try {
                await delete(id);
                _productController.getProducts();
                Get.back();
                Get.back();
                show('global_deleted_item'
                    .trParams({"item": "menu_product".tr}), color: success, duration: const Duration(seconds: 2));
              } catch (e) {
                Get.back();

                show('${'global_failed_delete_item'.trParams({'item': 'menu_product'.tr.toLowerCase()})} - ${'has_an_item'.trParams({'item': 'menu_transaction'.tr.toLowerCase()})}', color: error, duration: const Duration(seconds: 2));
              }
            },
            child: Text('global_delete'.tr),
          ),
        ],
      ),
    );
  }
}
