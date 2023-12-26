// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/auths/profile_response.dart';
import 'package:lakasir/widgets/camera_picker.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  static const routeName = '/menu/profile/edit';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameInputController = TextEditingController();
  TextEditingController _phoneInputController = TextEditingController();
  TextEditingController _emailInputController = TextEditingController();
  TextEditingController _addressInputController = TextEditingController();
  SelectInputWidgetController _languageController =
      SelectInputWidgetController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ProfileResponse profile =
        ModalRoute.of(context)!.settings.arguments as ProfileResponse;

    _nameInputController.text = profile.name;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Layout(
      title: 'Edit Profile',
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 30 / 100,
                child: CameraPicker(
                  onImageSelected: (file) {},
                ),
              ),
              SizedBox(
                width: width * 50 / 100,
                child: MyTextField(
                  controller: _nameInputController,
                  label: 'Name',
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              controller: _emailInputController,
              label: 'Email',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              controller: _phoneInputController,
              label: 'Phone',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              maxLines: 4,
              controller: _addressInputController,
              label: 'Address',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: SelectInputWidget(
              options: [
                Option(name: "Bahasa Indonesia", value: "indonesian"),
                Option(name: "English", value: "english"),
              ],
              controller: _languageController,
              label: 'Language',
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
