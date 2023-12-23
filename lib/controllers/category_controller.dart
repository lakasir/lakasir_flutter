import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/responses/categories/category_error_response.dart';
import 'package:lakasir/api/responses/categories/category_response.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/services/category_service.dart';
import 'package:lakasir/utils/colors.dart';

class CategoryController extends GetxController {
  CategoryService categoryService = CategoryService();
  Rx<bool> showAddCategory = false.obs;
  TextEditingController categoryNameController = TextEditingController();
  RxList<CategoryResponse> categories = <CategoryResponse>[].obs;
  final isFetching = false.obs;
  Rx<CategoryErrorResponse> errors = CategoryErrorResponse(
    name: "",
  ).obs;

  Rx<String> labelButton = "Add Category".obs;

  Future<void> fetchCategories() async {
    isFetching(true);
    final response = await categoryService.getCategories();
    categories.assignAll(response);
    isFetching(false);
  }

  Future<void> addCategory() async {
    labelButton("Add Category");
    if (categoryNameController.text.isEmpty) {
      showAddCategory(false);
      return;
    }
    try {
      await categoryService.addCategory(
        categoryNameController.text,
      );
      showAddCategory(false);
      categoryNameController.clear();
      fetchCategories();
    } catch (e) {
      if (e is ValidationException) {
        ErrorResponse<CategoryErrorResponse> errorResponses =
            ErrorResponse.fromJson(
          jsonDecode(
            e.toString(),
          ),
          (json) => CategoryErrorResponse.fromJson(json),
        );
        errors(errorResponses.errors);
      }
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await categoryService.deleteCategory(id);
      fetchCategories();
    } catch (e) {
      if (e is ValidationException) {
        ErrorResponse errorResponses =
            ErrorResponse.fromJson(jsonDecode(e.toString()), null);
        Get.rawSnackbar(message: errorResponses.message, backgroundColor: error);
      }
    }
  }

  void actionButton() {
    if (showAddCategory()) {
      addCategory();
      labelButton("Add Category");
    } else {
      showAddCategory(true);
      labelButton("Cancel");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  @override
  void onClose() {
    categoryNameController.dispose();
    super.onClose();
  }
}
