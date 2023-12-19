// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/members/member_response.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/text_field.dart';

class EditMemberScreen extends StatefulWidget {
  const EditMemberScreen({Key? key}) : super(key: key);

  static const routeName = '/menu/profile/edit';

  @override
  State<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  TextEditingController _nameInputController = TextEditingController();
  TextEditingController _codeInputController = TextEditingController();
  TextEditingController _addressInputController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final MemberResponse member =
        ModalRoute.of(context)!.settings.arguments as MemberResponse;

    _nameInputController.text = member.name;
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Edit Member',
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              controller: _nameInputController,
              label: "Name",
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              controller: _codeInputController,
              label: "Code",
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              maxLines: 4,
              controller: _addressInputController,
              label: "Address",
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
