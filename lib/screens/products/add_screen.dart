import 'package:flutter/material.dart';
import 'package:lakasir/widgets/image_picker.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final SelectInputWidgetController _categoryController =
      SelectInputWidgetController();
  final SelectInputWidgetController _typeController =
      SelectInputWidgetController();
  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _stockInputController = TextEditingController();
  final TextEditingController _initialPriceInputController =
      TextEditingController();
  final TextEditingController _sellingPriceInputController =
      TextEditingController();
  final TextEditingController _unitInputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Layout(
      title: 'Add Product',
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
