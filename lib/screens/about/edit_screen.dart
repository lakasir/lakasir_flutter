// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/abouts/about_response.dart';
import 'package:lakasir/widgets/camera_picker.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class EditAboutScreen extends StatefulWidget {
  const EditAboutScreen({Key? key}) : super(key: key);

  static const routeName = '/menu/profile/edit';

  @override
  State<EditAboutScreen> createState() => _EditAboutScreenState();
}

class _EditAboutScreenState extends State<EditAboutScreen> {
  TextEditingController _nameInputController = TextEditingController();
  TextEditingController _bussinessTypeInputController = TextEditingController();
  TextEditingController _locationInputController = TextEditingController();
  TextEditingController _ownerNameInputController = TextEditingController();
  SelectInputWidgetController _currencyInputController =
      SelectInputWidgetController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AboutResponse profile =
        ModalRoute.of(context)!.settings.arguments as AboutResponse;

    _nameInputController.text = profile.shopeName;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Layout(
      title: 'Edit About',
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 30 / 100,
                child: const CameraPicker(),
              ),
              SizedBox(
                width: width * 50 / 100,
                child: MyTextField(
                  controller: _nameInputController,
                  label: 'Shop Name',
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              controller: _bussinessTypeInputController,
              label: 'Bussiness Type',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              controller: _ownerNameInputController,
              label: "Owner's Name",
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              maxLines: 4,
              controller: _locationInputController,
              label: "Location",
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: SelectInputWidget(
              options: [
                Option(name: "IDR", value: "idr"),
                Option(name: "USD", value: "usd"),
              ],
              controller: _currencyInputController,
              label: 'Currency',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyFilledButton(
              onPressed: () {},
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
