import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/requests/product_request.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/category_controller.dart';
import 'package:lakasir/services/product_service.dart';
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
    showDialog(
      context: Get.context!,
      builder: (context) {
        return MyDialog(
          noPadding: true,
          content: Column(
            children: [
              MyTextField(
                hintText: 'Search Product',
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
        );
      },
    );
  }

  void showFilterDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return MyDialog(
          title: 'Filter Product',
          content: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: MyTextField(
                  hintText: 'Search Name',
                  controller: searchByNameController,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: SelectInputWidget(
                  hintText: 'Select Category',
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
                    hintText: 'Type',
                    controller: searchByTypeController,
                    options: [
                      Option(
                        value: 'product',
                        name: 'Product',
                      ),
                      Option(
                        value: 'service',
                        name: 'Service',
                      ),
                    ]),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: MyTextField(
                  hintText: 'Search Unit',
                  controller: searchByUnitController,
                ),
              ),
              MyFilledButton(
                onPressed: () {
                  isFiltered(true);
                  searchProduct();
                  Get.back();
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        );
      },
    );
  }

  void clearSearch() {
    searchByNameController.clear();
    searchByCategoryController.selectedOption = null;
    searchByTypeController.selectedOption = null;
    searchByUnitController.clear();
    getProducts();
  }

  @override
  void onInit() {
    getProducts();
    super.onInit();
  }
}
