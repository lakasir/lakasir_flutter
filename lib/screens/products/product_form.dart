import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/category_controller.dart';
import 'package:lakasir/controllers/products/product_add_controller.dart';
import 'package:lakasir/controllers/products/unit_controller.dart';
import 'package:lakasir/utils/colors.dart';
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
  final _unitController = Get.put(UnitController());
  final AuthController _authController = Get.put(AuthController());
  bool _isServiceType = false;
  bool showAddinitionalField = false;
  bool showInitialPrice = true;

  @override
  void initState() {
    super.initState();
    _unitController.fetchUnits();
    if (widget.controller.typeController.selectedOption == "service") {
      setState(() {
        _isServiceType = true;
        showInitialPrice = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _unitController.fetchUnits();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ListView(
      shrinkWrap: true,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Obx(
                  () => SelectInputWidget(
                    hintText: 'field_select_category'.tr,
                    mandatory: true,
                    controller: widget.controller.categoryController,
                    label: 'field_category'.tr,
                    errorText:
                        widget.controller.productErrorResponse.value.category ??
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
              if (_authController.feature(
                feature: 'product-type',
              ))
                const SizedBox(width: 20),
              if (_authController.feature(
                feature: 'product-type',
              ))
                Flexible(
                  child: Obx(
                    () => SelectInputWidget(
                      controller: widget.controller.typeController,
                      label: 'field_type'.tr,
                      errorText:
                          widget.controller.productErrorResponse.value.type ??
                              '',
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
                      onChanged: (value) {
                        widget.controller.initialPriceInputController
                            .updateValue(0);
                        setState(() {
                          _isServiceType = value == "service";
                          showInitialPrice = value == "product";
                        });
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_authController.feature(feature: 'product-stock'))
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'field_is_non_stock'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: secondary,
                  ),
                ),
                Obx(
                  () => Switch(
                    value: widget.controller.enabledStock.value,
                    onChanged: (value) {
                      widget.controller.enabledStock.value = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        if (_authController.feature(feature: 'product-stock'))
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Obx(
              () => MyTextField(
                readOnly: widget.controller.enabledStock.value,
                controller: widget.controller.stockInputController,
                label: 'field_stock'.tr,
                keyboardType: TextInputType.number,
                errorText:
                    widget.controller.productErrorResponse.value.stock ?? '',
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: showInitialPrice &&
                    _authController.feature(
                      feature: 'product-initial-price',
                    ),
                child: Flexible(
                  child: Obx(
                    () => MyTextField(
                      readOnly: _isServiceType,
                      controller: widget.controller.initialPriceInputController,
                      label: 'field_initial_price'.tr,
                      keyboardType: TextInputType.number,
                      errorText: widget.controller.productErrorResponse.value
                              .initialPrice ??
                          '',
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showInitialPrice &&
                    _authController.feature(
                      feature: 'product-initial-price',
                    ),
                child: const SizedBox(width: 20),
              ),
              Flexible(
                child: Obx(
                  () => MyTextField(
                    controller: widget.controller.sellingPriceInputController,
                    label: 'field_selling_price'.tr,
                    keyboardType: TextInputType.number,
                    errorText: widget.controller.productErrorResponse.value
                            .sellingPrice ??
                        '',
                  ),
                ),
              ),
            ],
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
        Obx(
          () => Row(
            children: [
              for (var unit in _unitController.units)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: primary,
                      ),
                      borderRadius: BorderRadius.circular(12), // Border radius
                    ),
                  ),
                  onPressed: () {
                    widget.controller.unitInputController.text = unit.name!;
                  },
                  child: Text(unit.name!),
                ),
              if (_unitController.units.isNotEmpty)
                Expanded(child: Container()),
              if (_unitController.units.isNotEmpty)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: primary,
                      ),
                      borderRadius: BorderRadius.circular(12), // Border radius
                    ),
                  ),
                  onPressed: () {
                    _unitController.clearUnit();
                    _unitController.fetchUnits();
                  },
                  child: const Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        if (_authController.feature(feature: 'product-sku') ||
            _authController.feature(feature: 'product-barcode'))
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                setState(() {
                  showAddinitionalField = !showAddinitionalField;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.blue[700],
                  ),
                  Text(
                    'additional_field'.tr,
                    style: TextStyle(
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        Visibility(
          visible: showAddinitionalField,
          child: Column(
            children: [
              if (_authController.feature(feature: 'product-sku'))
                Obx(
                  () => MyTextField(
                    controller: widget.controller.skuInputController,
                    label: 'field_sku'.tr,
                    errorText:
                        widget.controller.productErrorResponse.value.sku ?? '',
                    info: 'field_sku_info'.tr,
                  ),
                ),
              if (_authController.feature(feature: 'product-barcode'))
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Obx(
                    () => MyTextField(
                      controller: widget.controller.barcodeInputController,
                      label: 'field_barcode'.tr,
                      errorText: widget
                              .controller.productErrorResponse.value.barcode ??
                          '',
                      info: 'field_sku_info'.tr,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: Obx(
            () => MyFilledButton(
              onPressed: () {
                try {
                  widget.onSubmit();
                  _unitController.createOrUpdateUnit(
                    widget.controller.unitInputController.text,
                  );
                } catch (e) {
                  rethrow;
                }
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
