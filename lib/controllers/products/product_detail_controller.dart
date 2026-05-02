import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';
import 'package:lakasir/offline/repositories/product_repository.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';

class ProductDetailController extends GetxController {
  final _productRepository = ProductRepository();
  final ProductController _productController = Get.put(ProductController());
  final RxBool isLoading = false.obs;
  final Rx<OfflineProduct?> product = Rx<OfflineProduct?>(null);

  Future<void> delete(int id) async {
    await _productRepository.deleteProduct(id);
  }

  Future<void> get(int id) async {
    isLoading(true);
    product.value = await _productRepository.getProductById(id);
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
                    .trParams({"item": "menu_product".tr}));
              } catch (e) {
                Get.back();

                show(
                  "${'global_failed_delete_item'.trParams({'item': 'menu_product'.tr.toLowerCase()})}: ${'has_an_item'.trParams({'item': 'menu_transaction'.tr.toLowerCase()})}",
                  color: error,
                );
              }
            },
            child: Text('global_delete'.tr),
          ),
        ],
      ),
    );
  }
}