import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/products/product_add_controller.dart';
import 'package:lakasir/screens/products/product_form.dart';
import 'package:lakasir/widgets/layout.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductAddEditController _productAddController =
      Get.put(ProductAddEditController());

  @override
  void dispose() {
    _productAddController.clearInput();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      resizeToAvoidBottomInset: true,
      title: 'product_add'.tr,
      child: Form(
        key: _productAddController.formKey,
        child: ProductForm(
          onSubmit: () => _productAddController.create(),
          controller: _productAddController,
        ),
      ),
    );
  }
}
