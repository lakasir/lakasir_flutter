import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/requests/product_request.dart';
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
  RxList<ProductResponse> products = <ProductResponse>[].obs;
  final ProductService _productService = ProductService();
  final searchByNameController = TextEditingController();
  final searchByCategoryController = SelectInputWidgetController();
  final searchByTypeController = SelectInputWidgetController();
  final searchByUnitController = TextEditingController();
  RxBool isFiltered = false.obs;

  void getProducts() async {
    isLoading(true);
    final response = await _productService.get(ProductRequest());
    products.value = response.data!;
    isLoading(false);
  }

  void searchProduct() async {
    isLoading(true);
    final response = await _productService.get(ProductRequest(
      name: searchByNameController.text,
      categoryId: searchByCategoryController.selectedOption,
      type: searchByTypeController.selectedOption,
      unit: searchByUnitController.text,
    ));
    products.value = response.data!;
    isLoading(false);
  }

  void showSearchDialog() {
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
                searchProduct();
              },
              rightIcon: IconButton(
                onPressed: searchProduct,
                icon: const Icon(Icons.search),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFilterDialog() {
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
              searchProduct();
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
    getProducts();
  }

  String buildPrice(index) {
    if (products.isEmpty) {
      return '';
    }
    final price = products[index].sellingPrice;
    final unit = products[index].unit;
    return '${formatPrice(price!, isSymbol: false)} / $unit';
  }

  @override
  void onInit() {
    getProducts();
    super.onInit();
  }
}
