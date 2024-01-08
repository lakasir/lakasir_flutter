import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/category_controller.dart';
import 'package:lakasir/controllers/products/product_add_controller.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/image_picker.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final ProductAddEditController _productAddEditController =
      Get.put(ProductAddEditController());
  final CategoryController _categoryController = Get.put(CategoryController());

  @override
  void initState() {
    _productAddEditController.setData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _productAddEditController.clearInput();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Layout(
      title: 'Edit Product',
      resizeToAvoidBottomInset: true,
      child: Form(
        key: _productAddEditController.formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: MyImagePicker(
                    usingDynamicSource: true,
                    defaultImage: _productAddEditController.photoUrl ?? '',
                    onImageSelected: (file) {
                      _productAddEditController.photoUrl = file;
                    },
                  ),
                ),
                SizedBox(
                  width: width * 60 / 100,
                  child: MyTextField(
                    controller: _productAddEditController.nameInputController,
                    label: 'Product Name',
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
                  controller: _productAddEditController.categoryController,
                  label: 'Category',
                  errorText: _productAddEditController
                          .productErrorResponse.value.category ??
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
                  controller: _productAddEditController.stockInputController,
                  label: 'Stock',
                  keyboardType: TextInputType.number,
                  errorText: _productAddEditController
                          .productErrorResponse.value.stock ??
                      '',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyTextField(
                  controller:
                      _productAddEditController.initialPriceInputController,
                  label: 'Initial Price',
                  keyboardType: TextInputType.number,
                  errorText: _productAddEditController
                          .productErrorResponse.value.initialPrice ??
                      '',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyTextField(
                  controller:
                      _productAddEditController.sellingPriceInputController,
                  label: 'Selling Price',
                  keyboardType: TextInputType.number,
                  errorText: _productAddEditController
                          .productErrorResponse.value.sellingPrice ??
                      '',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => SelectInputWidget(
                  controller: _productAddEditController.typeController,
                  label: 'Type',
                  errorText: _productAddEditController
                          .productErrorResponse.value.type ??
                      '',
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
                  controller: _productAddEditController.unitInputController,
                  label: 'Unit',
                  mandatory: true,
                  errorText: _productAddEditController
                          .productErrorResponse.value.unit ??
                      '',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Obx(
                () => MyFilledButton(
                  onPressed: () {
                    _productAddEditController.edit();
                  },
                  isLoading: _productAddEditController.isLoading.value,
                  child: const Text('Update'),
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
