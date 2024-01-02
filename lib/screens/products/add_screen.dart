import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/category_controller.dart';
import 'package:lakasir/controllers/products/product_add_controller.dart';
import 'package:lakasir/widgets/image_picker.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductAddEditController _productAddController =
      Get.put(ProductAddEditController());
  final CategoryController _categoryController = Get.put(CategoryController());

  @override
  void dispose() {
    _productAddController.clearInput();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Layout(
      resizeToAvoidBottomInset: true,
      title: 'Add Product',
      child: Form(
        key: _productAddController.formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 25 / 100,
                  child: MyImagePicker(
                    usingDynamicSource: true,
                    onImageSelected: (file) {
                      _productAddController.photoUrl = file;
                    },
                  ),
                ),
                SizedBox(
                  width: width * 60 / 100,
                  child: Obx(
                    () => MyTextField(
                      controller: _productAddController.nameInputController,
                      label: 'Product Name',
                      mandatory: true,
                      errorText:
                          _productAddController.productErrorResponse.value.name ??
                              '',
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => SelectInputWidget(
                  hintText: 'Select Category',
                  mandatory: true,
                  controller: _productAddController.categoryController,
                  label: 'Category',
                  errorText:
                      _productAddController.productErrorResponse.value.category ??
                          '',
                  options: _categoryController.categories
                      .map(
                        (e) => Option(
                          name: e.name,
                          value: e.id.toString(),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyTextField(
                  controller: _productAddController.stockInputController,
                  label: 'Stock',
                  keyboardType: TextInputType.number,
                  errorText:
                      _productAddController.productErrorResponse.value.stock ??
                          '',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyTextField(
                  controller: _productAddController.initialPriceInputController,
                  label: 'Initial Price',
                  keyboardType: TextInputType.number,
                  errorText: _productAddController
                          .productErrorResponse.value.initialPrice ??
                      '',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyTextField(
                  controller: _productAddController.sellingPriceInputController,
                  label: 'Selling Price',
                  keyboardType: TextInputType.number,
                  errorText: _productAddController
                          .productErrorResponse.value.sellingPrice ??
                      '',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => SelectInputWidget(
                  controller: _productAddController.typeController,
                  label: 'Type',
                  errorText:
                      _productAddController.productErrorResponse.value.type ?? '',
                  options: [
                    Option(
                      name: "Product",
                      value: "product",
                    ),
                    Option(
                      name: "Service",
                      value: "service",
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyTextField(
                  controller: _productAddController.unitInputController,
                  label: 'Unit',
                  textCapitalization: TextCapitalization.words,
                  mandatory: true,
                  errorText:
                      _productAddController.productErrorResponse.value.unit ?? '',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Obx(
                () => MyFilledButton(
                  onPressed: () {
                    _productAddController.create();
                  },
                  isLoading: _productAddController.isLoading.value,
                  child: const Text('Save'),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
