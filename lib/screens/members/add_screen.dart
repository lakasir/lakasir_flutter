import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/members/member_add_controller.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/text_field.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final MemberAddController _memberAddController = Get.put(
    MemberAddController(),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _memberAddController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      resizeToAvoidBottomInset: true,
      title: 'Add Member',
      child: Form(
        key: _memberAddController.formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyTextField(
                  controller: _memberAddController.memberNameController,
                  mandatory: true,
                  label: "Name",
                  errorText:
                      _memberAddController.memberErrorResponse.value.name,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyTextField(
                controller: _memberAddController.memberCodeController,
                info:
                    "You can leave this field empty and will be generated automatically",
                label: "Code",
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyTextField(
                  controller: _memberAddController.memberEmailOrPhoneController,
                  label: "Email or Phone",
                  errorText:
                      _memberAddController.memberErrorResponse.value.email ??
                          "",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyTextField(
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                controller: _memberAddController.memberAddressController,
                label: "Address",
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyFilledButton(
                  onPressed: _memberAddController.addMember,
                  isLoading: _memberAddController.isSubmitting.value,
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
