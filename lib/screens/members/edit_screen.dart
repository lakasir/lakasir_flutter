import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/members/member_update_controller.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/text_field.dart';

class EditMemberScreen extends StatefulWidget {
  const EditMemberScreen({super.key});

  @override
  State<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  final MemberUpdateController _memberUpdateController = Get.put(
    MemberUpdateController(),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _memberUpdateController.setData();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Edit Member',
      resizeToAvoidBottomInset: true,
      child: Form(
        key: _memberUpdateController.formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyTextField(
                  controller: _memberUpdateController.memberNameController,
                  label: "Name",
                  errorText:
                      _memberUpdateController.memberErrorResponse.value.name,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyTextField(
                controller: _memberUpdateController.memberCodeController,
                info:
                    "You can leave this field empty and will be generated automatically",
                label: "Code",
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyTextField(
                  controller:
                      _memberUpdateController.memberEmailOrPhoneController,
                  label: "Email Or Phone",
                  errorText:
                      _memberUpdateController.memberErrorResponse.value.email ??
                          "",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyTextField(
                maxLines: 4,
                controller: _memberUpdateController.memberAddressController,
                textInputAction: TextInputAction.newline,
                label: "Address",
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyFilledButton(
                onPressed: _memberUpdateController.updateMember,
                isLoading: _memberUpdateController.isSubmitting.value,
                child: const Text('Save'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyFilledButton(
                onPressed: () => _memberUpdateController.deleteMember(),
                isLoading: _memberUpdateController.isSubmitting.value,
                color: error,
                child: const Row(
                  children: [
                    Text('Delete'),
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
