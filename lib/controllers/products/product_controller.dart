import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/requests/product_request.dart';
import 'package:lakasir/api/responses/pagination_response.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/category_controller.dart';
import 'package:lakasir/services/product_service.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class ProductController extends GetxController {
  final CategoryController _categoryController = Get.put(CategoryController());
  RxBool isLoading = false.obs;
  final ProductService _productService = ProductService();
  final searchByNameController = TextEditingController();
  final searchByCategoryController = SelectInputWidgetController();
  final searchByTypeController = SelectInputWidgetController();
  final searchByUnitController = TextEditingController();
  RxBool isFiltered = false.obs;
  RxInt refreshTrigger = 0.obs;
  static const int perPage = 20;

  void getProducts() {
    refreshTrigger++;
  }

  Future<PaginationResponse<ProductResponse>> fetchPage(int pageKey) async {
    final request = ProductRequest(
      name: searchByNameController.text.isEmpty
          ? null
          : searchByNameController.text,
      categoryId: searchByCategoryController.selectedOption,
      type: searchByTypeController.selectedOption,
      unit: searchByUnitController.text.isEmpty
          ? null
          : searchByUnitController.text,
      page: pageKey + 1,
      perPage: perPage,
    );
    return await _productService.get(request);
  }

  void showSearchDialog({VoidCallback? onRefresh}) {
    Get.dialog(
      MyDialog(
        noPadding: true,
        content: Column(
          children: [
            MyTextField(
              hintText: 'field_product_name'.tr,
              controller: searchByNameController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                onRefresh?.call();
                Get.back();
              },
              rightIcon: IconButton(
                onPressed: () {
                  onRefresh?.call();
                  Get.back();
                },
                icon: const Icon(Icons.search),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFilterDialog({VoidCallback? onRefresh}) {
    Get.dialog(MyDialog(
      title: 'global_filter_item'.trParams({'item': 'menu_product'.tr}),
      content: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: MyTextField(
              hintText: 'field_product_name'.tr,
              controller: searchByNameController,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: SelectInputWidget(
              hintText: 'field_select_category'.tr,
              controller: searchByCategoryController,
              options: _categoryController.categories
                  .map((e) => Option(
                        value: e.id.toString(),
                        name: e.name,
                      ))
                  .toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: SelectInputWidget(
                hintText: 'field_type'.tr,
                controller: searchByTypeController,
                options: [
                  Option(
                    value: 'product',
                    name: 'option_product'.tr,
                  ),
                  Option(
                    value: 'service',
                    name: 'option_service'.tr,
                  ),
                ]),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: MyTextField(
              hintText: 'field_unit'.tr,
              controller: searchByUnitController,
            ),
          ),
          MyFilledButton(
            onPressed: () {
              isFiltered(true);
              onRefresh?.call();
              Get.back();
            },
            child: Text("global_filter".tr),
          ),
        ],
      ),
    ));
  }

  void clearSearch() {
    searchByNameController.clear();
    searchByCategoryController.selectedOption = null;
    searchByTypeController.selectedOption = null;
    searchByUnitController.clear();
    isFiltered(false);
  }

  String buildPrice(ProductResponse product) {
    final price = product.sellingPrice;
    final unit = product.unit;
    return '${formatPrice(price!, isSymbol: false)} / $unit';
  }
}
