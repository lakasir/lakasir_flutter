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
  final formKey = GlobalKey<FormState>();
  CategoryService categoryService = CategoryService();
  Rx<bool> showAddCategory = false.obs;
  TextEditingController categoryNameController = TextEditingController();
  RxList<CategoryResponse> categories = <CategoryResponse>[].obs;
  final isFetching = false.obs;
  Rx<CategoryErrorResponse> errors = CategoryErrorResponse(
    name: "",
  ).obs;

  Future<void> fetchCategories() async {
    isFetching(true);
    final response = await categoryService.getCategories();
    categories.assignAll(response);
    isFetching(false);
  }

  Future<void> addCategory() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      await categoryService.addCategory(
        categoryNameController.text,
      );
      showAddCategory(false);
      categoryNameController.clear();
      fetchCategories();
      Get.back();
      Get.rawSnackbar(
        message: 'global_added_item'.trParams({
          'item': 'setting_category'.tr,
        }),
        backgroundColor: success,
      );
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

  Future<void> updateCategory(int id) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      await categoryService.updateCategory(
        id,
        categoryNameController.text,
      );
      showAddCategory(false);
      categoryNameController.clear();
      fetchCategories();
      Get.back();
      Get.rawSnackbar(
        message: 'global_updated_item'.trParams({
          'item': 'setting_category'.tr,
        }),
        backgroundColor: success,
      );
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
