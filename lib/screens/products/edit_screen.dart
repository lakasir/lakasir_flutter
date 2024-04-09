import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/products/product_add_controller.dart';
import 'package:lakasir/screens/products/product_form.dart';
import 'package:lakasir/widgets/layout.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final ProductAddEditController _productAddEditController =
      Get.put(ProductAddEditController());

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
    return Layout(
      title: 'product_edit'.tr,
      resizeToAvoidBottomInset: true,
      child: Form(
        key: _productAddEditController.formKey,
        child: ProductForm(onSubmit: () => _productAddEditController.edit(), controller: _productAddEditController),
      ),
    );
  }
}
