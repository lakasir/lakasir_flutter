// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/profiles/profile_edit_controller.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/image_picker.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ProfileEditController _profileController = Get.put(ProfileEditController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Layout(
      title: 'global_edit_item'.trParams({
        'item': 'menu_profile'.tr,
      }),
      child: Form(
        key: _profileController.formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => SizedBox(
                    width: 100,
                    child: MyImagePicker(
                      onImageSelected: (file) {
                        _profileController.profile.value.photoUrl = file;
                      },
                      usingDynamicSource: true,
                      defaultImage: _profileController.profile.value.photoUrl
                              ?.replaceFirst("https", "http") ??
                          '',
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 60 / 100,
                  child: Obx(
                    () => MyTextField(
                      controller: _profileController.nameInputController,
                      label: 'field_name'.tr,
                      errorText:
                          _profileController.profileErrorResponse.value.name,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyTextField(
                controller: _profileController.emailInputController,
                label: 'field_email'.tr,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyTextField(
                  controller: _profileController.phoneInputController,
                  label: 'field_phone'.tr,
                  errorText:
                      _profileController.profileErrorResponse.value.phone,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyTextField(
                maxLines: 4,
                controller: _profileController.addressInputController,
                label: 'field_address'.tr,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyFilledButton(
                  onPressed: _profileController.updateProfile,
                  isLoading: _profileController.isLoading.value,
                  child: Text('global_save'.tr),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
