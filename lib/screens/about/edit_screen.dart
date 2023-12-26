// ignore_for_file: prefer_final_fields
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakasir/controllers/abouts/about_edit_controller.dart';
import 'package:lakasir/widgets/camera_picker.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';


class EditAboutScreen extends StatefulWidget {
  const EditAboutScreen({super.key});

  @override
  State<EditAboutScreen> createState() => _EditAboutScreenState();
}

class _EditAboutScreenState extends State<EditAboutScreen> {
  AboutEditController aboutEditController = Get.put(AboutEditController());


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final AboutResponse profile =
    //     ModalRoute.of(context)!.settings.arguments as AboutResponse;
    //
    // _nameInputController.text = profile.shopeName ?? '';
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
                child: CameraPicker(
                  onImageSelected: (file) {
                    print("uploading image");
                    print(file);
                  },
                ),
              ),
              SizedBox(
                width: width * 50 / 100,
                child: MyTextField(
                  controller: aboutEditController.nameInputController,
                  label: 'Shop Name',
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              controller: aboutEditController.bussinessTypeInputController,
              label: 'Bussiness Type',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              controller: aboutEditController.ownerNameInputController,
              label: "Owner's Name",
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              maxLines: 4,
              controller: aboutEditController.locationInputController,
              label: "Location",
              textInputAction: TextInputAction.newline,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: SelectInputWidget(
              options: [
                Option(name: "IDR", value: "idr"),
              ],
              controller: aboutEditController.currencyInputController,
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
