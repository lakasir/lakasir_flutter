import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/api/responses/products/produect_error_response.dart';
import 'package:lakasir/controllers/category_controller.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/offline/models/offline_category_model.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';
import 'package:lakasir/offline/repositories/product_repository.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:path_provider/path_provider.dart';

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

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation_required'.trParams({'field': 'field_product_name'.tr});
    }
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation_required'.trParams({'field': 'field_category'.tr});
    }
    return null;
  }

  String? validateUnit(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation_required'.trParams({'field': 'field_unit'.tr});
    }
    return null;
  }

  String? validateSellingPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation_required'
          .trParams({'field': 'field_selling_price'.tr});
    }
    final sellingPrice = sellingPriceInputController.numberValue;
    final initialPrice = initialPriceInputController.numberValue;
    if (sellingPrice < initialPrice) {
      return 'validation_selling_price_greater_than_initial_price'.tr;
    }
    return null;
  }

  String? validateInitialPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation_required'
          .trParams({'field': 'field_initial_price'.tr});
    }
    return null;
  }

  String _generateSku(int productId, String categoryName, String productName) {
    final prefix = categoryName.length >= 3
        ? categoryName.substring(0, 3).toUpperCase()
        : categoryName.toUpperCase();
    final namePrefix = productName.length >= 3
        ? productName.substring(0, 3).toUpperCase()
        : productName.toUpperCase();
    final idPadded = productId.abs().toString().padLeft(4, '0');
    return '$prefix-$namePrefix-$idPadded';
  }

  String _generateBarcode(
      int productId, String categoryName, String productName) {
    final prefix = categoryName.length >= 3
        ? categoryName.substring(0, 3).toUpperCase()
        : categoryName.toUpperCase();
    final namePrefix = productName.length >= 3
        ? productName.substring(0, 3).toUpperCase()
        : productName.toUpperCase();
    final idPadded = productId.abs().toString().padLeft(4, '0');
    return '$prefix-$namePrefix-$idPadded';
  }

  String? _getCategoryName() {
    final categoryId = categoryController.selectedOption != null
        ? int.parse(categoryController.selectedOption!)
        : null;
    if (categoryId == null) return null;

    // Find category name from the categories list
    final catController = Get.find<CategoryController>();
    try {
      final OfflineCategory category = catController.categories
          .firstWhere((c) => c.id == categoryId);
      return category.name;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _saveAndCompressImage(String filePath) async {
    try {
      final File imageFile = File(filePath);
      if (!await imageFile.exists()) return null;

      final bytes = await imageFile.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);
      if (image == null) return null;

      // Resize if width > 512 pixels
      img.Image processedImage = image;
      if (image.width > 512) {
        final int newHeight =
            (image.height * 512 / image.width).round();
        processedImage = img.copyResize(image, width: 512, height: newHeight);
      }

      // Encode as JPEG with quality 70
      final compressedBytes = img.encodeJpg(processedImage, quality: 70);

      // Save to app documents directory
      final dir = await getApplicationDocumentsDirectory();
      final String fileName =
          'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String savedPath = '${dir.path}/$fileName';
      final File savedFile = File(savedPath);
      await savedFile.writeAsBytes(compressedBytes);

      return savedPath;
    } catch (e) {
      debugPrint('Error saving image: $e');
      return null;
    }
  }

  void create() async {
    if (isLoading.value) return;

    try {
      clearError();
      isLoading(true);

      if (!formKey.currentState!.validate()) {
        isLoading(false);
        return;
      }

      String? savedImagePath;
      if (photoUrl != null && photoUrl!.isNotEmpty) {
        if (!photoUrl!.startsWith('http') && !photoUrl!.contains('product_')) {
          savedImagePath = await _saveAndCompressImage(photoUrl!);
        } else {
          savedImagePath = photoUrl;
        }
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
        ..image = savedImagePath ?? ''
        ..isNonStock = enabledStock.value
        ..sku = skuInputController.text
        ..barcode = barcodeInputController.text;

      await _productRepository.createProduct(product);

      final categoryName = _getCategoryName() ?? '';
      final productId = product.id;
      if (skuInputController.text.isEmpty) {
        product.sku = _generateSku(productId, categoryName, product.name);
      }
      if (barcodeInputController.text.isEmpty) {
        product.barcode =
            _generateBarcode(productId, categoryName, product.name);
      }

      if (skuInputController.text.isEmpty ||
          barcodeInputController.text.isEmpty) {
        await _productRepository.updateProduct(product);
      }

      _productController.getProducts();
      clearInput();
      isLoading(false);
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
      } else {
        debugPrint('Unexpected error during product creation: $e');
        Get.rawSnackbar(
          message: 'global_error_occurred'.tr,
          backgroundColor: error,
        );
      }
    }
  }

  void edit() async {
    if (isLoading.value) return;

    try {
      clearError();
      isLoading(true);

      if (!formKey.currentState!.validate()) {
        isLoading(false);
        return;
      }

      String? savedImagePath;
      if (photoUrl != null && photoUrl!.isNotEmpty) {
        if (!photoUrl!.startsWith('http') && !photoUrl!.contains('product_')) {
          savedImagePath = await _saveAndCompressImage(photoUrl!);
        } else {
          savedImagePath = photoUrl;
        }
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
        ..image = savedImagePath ?? ''
        ..isNonStock = enabledStock.value
        ..sku = skuInputController.text
        ..barcode = barcodeInputController.text;

      await _productRepository.updateProduct(product);

      // Auto-generate SKU and barcode if empty
      final categoryName = _getCategoryName() ?? '';
      if (product.sku.isEmpty) {
        product.sku =
            _generateSku(product.id, categoryName, product.name);
      }
      if (product.barcode == null || product.barcode!.isEmpty) {
        product.barcode =
            _generateBarcode(product.id, categoryName, product.name);
      }

      if (skuInputController.text.isEmpty ||
          barcodeInputController.text.isEmpty) {
        await _productRepository.updateProduct(product);
      }

      _productController.getProducts();
      clearInput();
      isLoading(false);
      Get.until((route) => route.settings.name == '/menu/product');
      Get.rawSnackbar(
        message: 'global_updated_item'.trParams({'item': 'menu_product'.tr}),
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
      } else {
        debugPrint('Unexpected error during product update: $e');
        Get.rawSnackbar(
          message: 'global_error_occurred'.tr,
          backgroundColor: error,
        );
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

