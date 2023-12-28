import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/abouts/about_edit_controller.dart';
import 'package:lakasir/widgets/image_picker.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';

class EditAboutScreen extends StatefulWidget {
  const EditAboutScreen({super.key});

  @override
  State<EditAboutScreen> createState() => _EditAboutScreenState();
}

class _EditAboutScreenState extends State<EditAboutScreen> {
  final AboutEditController _aboutEditController =
      Get.put(AboutEditController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Layout(
      title: 'Edit About',
      child: Form(
        key: _aboutEditController.formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => SizedBox(
                    width: width * 30 / 100,
                    child: MyImagePicker(
                      usingDynamicSource: true,
                      onImageSelected: (file) {
                        _aboutEditController.about.value.photo = file;
                      },
                      defaultImage: _aboutEditController.about.value.photo
                              ?.replaceFirst("https", "http") ??
                          '',
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 50 / 100,
                  child: MyTextField(
                    controller: _aboutEditController.nameInputController,
                    label: 'Shop Name',
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: SelectInputWidget(
                options: [
                  Option(name: "Retail", value: "retail"),
                  Option(name: "Wholesale", value: "wholesale"),
                ],
                controller: _aboutEditController.businessTypeInputController,
                label: 'Business Type',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyTextField(
                controller: _aboutEditController.ownerNameInputController,
                label: "Owner's Name",
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyTextField(
                maxLines: 4,
                controller: _aboutEditController.locationInputController,
                label: "Location",
                textInputAction: TextInputAction.newline,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: SelectInputWidget(
                options: [
                  Option(name: "IDR", value: "IDR"),
                ],
                controller: _aboutEditController.currencyInputController,
                label: 'Currency',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyFilledButton(
                  onPressed: _aboutEditController.updateAbout,
                  isLoading: _aboutEditController.isLoading.value,
                  child: const Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
