import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/api/responses/products/produect_error_response.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';
import 'package:lakasir/offline/repositories/product_repository.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/select_input_feld.dart';

class ProductAddEditController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ProductRepository _productRepository = ProductRepository();
  final SelectInputWidgetController categoryController =
      SelectInputWidgetController();
  final SelectInputWidgetController typeController =
      SelectInputWidgetController();
  final TextEditingController nameInputController = TextEditingController();
  final TextEditingController stockInputController = TextEditingController();
  final MoneyMaskedTextController initialPriceInputController =
      MoneyMaskedTextController(
    initialValue: 0.0,
  );
  final MoneyMaskedTextController sellingPriceInputController =
      MoneyMaskedTextController(
    initialValue: 0.0,
  );
  final TextEditingController unitInputController = TextEditingController();
  final TextEditingController expiredController = TextEditingController();
  final TextEditingController skuInputController = TextEditingController();
  final TextEditingController barcodeInputController = TextEditingController();
  String? photoUrl = '';
  Rx<ProductErrorResponse> productErrorResponse = ProductErrorResponse().obs;
  final RxBool isLoading = false.obs;
  final ProductController _productController = Get.put(ProductController());
  RxBool enabledStock = false.obs;

  void create() async {
    try {
      clearError();
      isLoading(true);
      if (!formKey.currentState!.validate()) {
        debugPrint('error');
        isLoading(false);
        return;
      }
      final product = OfflineProduct()
        ..name = nameInputController.text
        ..categoryId = categoryController.selectedOption != null
            ? int.parse(categoryController.selectedOption!)
            : null
        ..stock = stockInputController.text.isNotEmpty
            ? double.parse(stockInputController.text).toInt()
            : 0
        ..initialPrice = initialPriceInputController.numberValue
        ..sellingPrice = sellingPriceInputController.numberValue
        ..type = typeController.selectedOption ?? 'product'
        ..unit = unitInputController.text
        ..image = photoUrl
        ..isNonStock = enabledStock.value
        ..sku = skuInputController.text
        ..barcode = barcodeInputController.text;
      await _productRepository.createProduct(product);
      isLoading(false);
      _productController.getProducts();
      clearInput();
      Get.back();
      Get.rawSnackbar(
        message: 'product_add_success'.tr,
        backgroundColor: success,
      );
    } catch (e) {
      isLoading(false);
      if (e is ValidationException) {
        ErrorResponse<ProductErrorResponse> errorResponse =
            ErrorResponse.fromJson(
          jsonDecode(
            e.toString(),
          ),
          (json) => ProductErrorResponse.fromJson(json),
        );
        productErrorResponse(errorResponse.errors);
        Get.rawSnackbar(
          message: errorResponse.message,
          backgroundColor: error,
        );
      }
    }
  }

  void edit() async {
    try {
      clearError();
      isLoading(true);
      if (!formKey.currentState!.validate()) {
        isLoading(false);
        return;
      }
      final args = Get.arguments as OfflineProduct;
      final product = OfflineProduct()
        ..id = args.id
        ..name = nameInputController.text
        ..categoryId = categoryController.selectedOption != null
            ? int.parse(categoryController.selectedOption!)
            : null
        ..stock = stockInputController.text.isNotEmpty
            ? double.parse(stockInputController.text).toInt()
            : 0
        ..initialPrice = initialPriceInputController.numberValue
        ..sellingPrice = sellingPriceInputController.numberValue
        ..type = typeController.selectedOption ?? 'product'
        ..unit = unitInputController.text
        ..image = photoUrl ?? ''
        ..isNonStock = enabledStock.value
        ..sku = skuInputController.text
        ..barcode = barcodeInputController.text;
      await _productRepository.updateProduct(product);
      isLoading(false);
      _productController.getProducts();
      clearInput();
      Get.back();
      Get.back();
      Get.rawSnackbar(
        message: 'global_updated_item'.trParams({'item': 'menu_product'.tr}),
        backgroundColor: success,
      );
    } catch (e) {
      debugPrint(e.toString());
      isLoading(false);
      if (e is ValidationException) {
        ErrorResponse<ProductErrorResponse> errorResponse =
            ErrorResponse.fromJson(
          jsonDecode(
            e.toString(),
          ),
          (json) => ProductErrorResponse.fromJson(json),
        );
        productErrorResponse(errorResponse.errors);
      }
    }
  }

  void clearInput() {
    nameInputController.clear();
    stockInputController.clear();
    initialPriceInputController.clear();
    sellingPriceInputController.clear();
    unitInputController.clear();
    photoUrl = '';
    categoryController.selectedOption = null;
    skuInputController.clear();
    barcodeInputController.clear();
    enabledStock(false);
  }

  void clearError() {
    productErrorResponse(ProductErrorResponse());
  }

  @override
  void onInit() {
    super.onInit();
    typeController.selectedOption = 'product';
  }

  void setData() {
    if (Get.arguments != null) {
      final products = Get.arguments as OfflineProduct;
      nameInputController.text = products.name;
      categoryController.selectedOption = products.categoryId.toString();
      stockInputController.text = products.stock.toString();
      initialPriceInputController.updateValue(products.initialPrice ?? 0);
      sellingPriceInputController.updateValue(products.sellingPrice ?? 0);
      unitInputController.text = products.unit;
      photoUrl = products.image;
      skuInputController.text = products.sku;
      barcodeInputController.text = products.barcode ?? '';
      enabledStock(products.isNonStock);
    }
  }
}