import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/category_controller.dart';
import 'package:lakasir/controllers/products/product_add_controller.dart';
import 'package:lakasir/widgets/checkbox.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/image_picker.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({
    super.key,
    required this.onSubmit,
    required this.controller,
  });
  final VoidCallback onSubmit;
  final ProductAddEditController controller;

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
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
                  widget.controller.photoUrl = file;
                },
              ),
            ),
            SizedBox(
              width: width * 60 / 100,
              child: Obx(
                () => MyTextField(
                  controller: widget.controller.nameInputController,
                  label: 'field_product_name'.tr,
                  mandatory: true,
                  errorText:
                      widget.controller.productErrorResponse.value.name ?? '',
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Obx(
            () => MyTextField(
              mandatory: true,
              controller: widget.controller.skuInputController,
              label: 'field_sku'.tr,
              errorText:
                  widget.controller.productErrorResponse.value.sku ??
                      '',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Obx(
            () => MyTextField(
              controller: widget.controller.barcodeInputController,
              label: 'field_barcode'.tr,
              errorText:
                  widget.controller.productErrorResponse.value.barcode ??
                      '',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Obx(
            () => SelectInputWidget(
              hintText: 'field_select_category'.tr,
              mandatory: true,
              controller: widget.controller.categoryController,
              label: 'field_category'.tr,
              errorText:
                  widget.controller.productErrorResponse.value.category ?? '',
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
              readOnly: widget.controller.enabledStock.value,
              rightIcon: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    color: Colors.grey[200],
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 7),
                    child: MyCheckbox(
                      isChecked: widget.controller.enabledStock.value,
                      onChange: (value) {
                        widget.controller.enabledStock.value = value;
                      },
                    ),
                  ),
                ),
              ),
              controller: widget.controller.stockInputController,
              label: 'field_stock'.tr,
              info: 'field_stock_info'.tr,
              keyboardType: TextInputType.number,
              errorText:
                  widget.controller.productErrorResponse.value.stock ?? '',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Obx(
            () => MyTextField(
              controller: widget.controller.initialPriceInputController,
              label: 'field_initial_price'.tr,
              keyboardType: TextInputType.number,
              errorText:
                  widget.controller.productErrorResponse.value.initialPrice ??
                      '',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Obx(
            () => MyTextField(
              controller: widget.controller.sellingPriceInputController,
              label: 'field_selling_price'.tr,
              keyboardType: TextInputType.number,
              errorText:
                  widget.controller.productErrorResponse.value.sellingPrice ??
                      '',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Obx(
            () => SelectInputWidget(
              controller: widget.controller.typeController,
              label: 'field_type'.tr,
              errorText:
                  widget.controller.productErrorResponse.value.type ?? '',
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
              controller: widget.controller.unitInputController,
              label: 'field_unit'.tr,
              textCapitalization: TextCapitalization.words,
              mandatory: true,
              errorText:
                  widget.controller.productErrorResponse.value.unit ?? '',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: Obx(
            () => MyFilledButton(
              onPressed: () {
                widget.onSubmit();
              },
              isLoading: widget.controller.isLoading.value,
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
