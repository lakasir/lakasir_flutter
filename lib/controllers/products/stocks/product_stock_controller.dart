import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/requests/product_stock_request.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/api/responses/products/stocks/stock_error_response.dart';
import 'package:lakasir/api/responses/products/stocks/stock_response.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/controllers/products/product_detail_controller.dart';
import 'package:lakasir/services/product_stock_service.dart';
import 'package:lakasir/utils/colors.dart';

class ProductStockController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  final _productStockService = ProductStockService();
  final _productDetailController = Get.put(ProductDetailController());
  final _productController = Get.put(ProductController());
  final RxList<StockResponse> stocks = <StockResponse>[].obs;
  TextEditingController dateInputEditingController = TextEditingController();
  TextEditingController initialPriceInputEditingController =
      TextEditingController();
  TextEditingController stockInputEditingController = TextEditingController();
  TextEditingController sellingPriceInputEditingController =
      TextEditingController();
  final Rx<String> type = 'in'.obs;
  final Rx<StockErrorResponse> stockErrorResponse = StockErrorResponse().obs;

  Future<void> get(int id) async {
    if (id == 0) return;
    isLoading(true);
    final response = await _productStockService.get(id);
    stocks.value = response.data!;
    isLoading(false);
  }

  Future<void> delete(int productId, int id) async {
    isLoading(true);
    await _productStockService.delete(productId, id);
    refetch();
    isLoading(false);
  }

  Future<void> create(int id) async {
    try {
      isLoading(true);
      if (!formKey.currentState!.validate()) {
        isLoading(false);
        return;
      }
      await _productStockService.create(
        id,
        ProductStockRequest(
          type: type.value,
          stock: int.parse(stockInputEditingController.text),
          initialPrice: initialPriceInputEditingController.text,
          sellingPrice: sellingPriceInputEditingController.text,
          date: dateInputEditingController.text,
        ),
      );
      refetch();
      isLoading(false);
      clear();
      Get.back();
      Get.rawSnackbar(
        title: 'Success',
        message: 'Stock has been added',
        backgroundColor: success,
      );
    } catch (e) {
      isLoading(false);
      if (e is ValidationException) {
        ErrorResponse<StockErrorResponse> errorResponse =
            ErrorResponse.fromJson(
          jsonDecode(
            e.toString(),
          ),
          (json) => StockErrorResponse.fromJson(json),
        );
        stockErrorResponse(errorResponse.errors);
      }
    }
  }

  void refetch() {
    var id = _productDetailController.product.value.id;
    get(id);
    _productDetailController.get(id);
    _productController.getProducts();
  }

  void clear() {
    dateInputEditingController.clear();
    initialPriceInputEditingController.clear();
    stockInputEditingController.clear();
    sellingPriceInputEditingController.clear();
  }
}
