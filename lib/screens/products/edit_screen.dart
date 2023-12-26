import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/image_picker.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // TODO: fix this bug controller, user can't update the value
  final SelectInputWidgetController _categoryController =
      SelectInputWidgetController();
  final SelectInputWidgetController _typeController =
      SelectInputWidgetController();
  TextEditingController _nameInputController = TextEditingController();
  TextEditingController _stockInputController = TextEditingController();
  TextEditingController _initialPriceInputController = TextEditingController();
  TextEditingController _sellingPriceInputController = TextEditingController();
  TextEditingController _unitInputController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ProductResponse products =
        ModalRoute.of(context)!.settings.arguments as ProductResponse;

    _nameInputController = TextEditingController(text: products.name);
    _stockInputController =
        TextEditingController(text: products.stock.toString());
    _initialPriceInputController =
        TextEditingController(text: products.initialPrice.toString());
    _sellingPriceInputController =
        TextEditingController(text: products.sellingPrice.toString());
    _unitInputController = TextEditingController(text: products.unit);
  }

  @override
  void dispose() {
    // _categoryController.dispose();
    // _typeController.dispose();
    _nameInputController.dispose();
    _stockInputController.dispose();
    _initialPriceInputController.dispose();
    _sellingPriceInputController.dispose();
    _unitInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Layout(
      title: 'Edit Product',
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 30 / 100,
                child: MyImagePicker(
                  onImageSelected: (file) {
                    print(file);
                  },
                ),
              ),
              SizedBox(
                width: width * 50 / 100,
                child: MyTextField(
                  controller: _nameInputController,
                  label: 'Product Name',
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SelectInputWidget(
            controller: _categoryController,
            label: 'Category',
            errorText: "Category is required",
            options: [
              Option(
                name: "Option 1",
                value: "option_1",
              ),
              Option(
                name: "Option 2",
                value: "option_2",
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          MyTextField(
            controller: _stockInputController,
            label: 'Stock',
            errorText: "Stock is required",
          ),
          const SizedBox(
            height: 20,
          ),
          MyTextField(
            controller: _initialPriceInputController,
            label: 'Initial Price',
          ),
          const SizedBox(
            height: 20,
          ),
          MyTextField(
            controller: _sellingPriceInputController,
            label: 'Selling Price',
          ),
          const SizedBox(
            height: 20,
          ),
          SelectInputWidget(
            controller: _typeController,
            label: 'Type',
            options: [
              Option(
                name: "Product",
                value: "product",
              ),
              Option(
                name: "Service",
                value: "service",
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          MyTextField(
            controller: _unitInputController,
            label: 'Unit',
          ),
          const SizedBox(
            height: 40,
          ),
          MyFilledButton(
            onPressed: () {},
            child: const Text('Save'),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
