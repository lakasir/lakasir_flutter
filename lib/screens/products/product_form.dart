import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/category_controller.dart';
import 'package:lakasir/controllers/products/product_add_controller.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/image_picker.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class ProductForm extends StatelessWidget {
  ProductForm({
    super.key,
    required this.onSubmit,
    required this.controller,
  });
  final VoidCallback onSubmit;
  final ProductAddEditController controller;
  final CategoryController _categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ListView(
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
                  controller.photoUrl = file;
                },
              ),
            ),
            SizedBox(
              width: width * 60 / 100,
              child: Obx(
                () => MyTextField(
                  controller: controller.nameInputController,
                  label: 'field_product_name'.tr,
                  mandatory: true,
                  errorText: controller.productErrorResponse.value.name ?? '',
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Obx(
            () => SelectInputWidget(
              hintText: 'field_select_category'.tr,
              mandatory: true,
              controller: controller.categoryController,
              label: 'field_category'.tr,
              errorText: controller.productErrorResponse.value.category ?? '',
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
              controller: controller.stockInputController,
              label: 'field_stock'.tr,
              keyboardType: TextInputType.number,
              errorText: controller.productErrorResponse.value.stock ?? '',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Obx(
            () => MyTextField(
              controller: controller.initialPriceInputController,
              label: 'field_initial_price'.tr,
              keyboardType: TextInputType.number,
              errorText:
                  controller.productErrorResponse.value.initialPrice ?? '',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Obx(
            () => MyTextField(
              controller: controller.sellingPriceInputController,
              label: 'field_selling_price'.tr,
              keyboardType: TextInputType.number,
              errorText:
                  controller.productErrorResponse.value.sellingPrice ?? '',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Obx(
            () => SelectInputWidget(
              controller: controller.typeController,
              label: 'field_type'.tr,
              errorText: controller.productErrorResponse.value.type ?? '',
              options: [
                Option(
                  name: "option_product".tr,
                  value: "product",
                ),
                Option(
                  name: "option_service".tr,
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
              controller: controller.unitInputController,
              label: 'field_unit'.tr,
              textCapitalization: TextCapitalization.words,
              mandatory: true,
              errorText: controller.productErrorResponse.value.unit ?? '',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: Obx(
            () => MyFilledButton(
              onPressed: () {
                onSubmit();
              },
              isLoading: controller.isLoading.value,
              child: Text('global_save'.tr),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
