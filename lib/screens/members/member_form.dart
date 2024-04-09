import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/text_field.dart';

class MemberForm extends StatefulWidget {
  const MemberForm({
    super.key,
    required this.controller,
    required this.onPressed,
    this.isUpdate,
  });
  final dynamic controller;
  final void Function() onPressed;
  final bool? isUpdate;

  @override
  State<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Obx(
              () => MyTextField(
                controller: widget.controller.memberNameController,
                mandatory: true,
                label: 'field_name'.tr,
                errorText: widget.controller.memberErrorResponse.value.name,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              controller: widget.controller.memberCodeController,
              info: "info_leave_empty".tr,
              label: "field_code".tr,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Obx(
              () => MyTextField(
                controller: widget.controller.memberEmailOrPhoneController,
                label: "field_email_or_phone".tr,
                errorText:
                    widget.controller.memberErrorResponse.value.email ?? "",
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              controller: widget.controller.memberAddressController,
              label: "field_address".tr,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Obx(
              () => MyFilledButton(
                onPressed: widget.onPressed,
                isLoading: widget.controller.isSubmitting.value,
                child: Text('global_save'.tr),
              ),
            ),
          ),
          if (widget.isUpdate == true &&
              can(
                _authController.permissions,
                'delete member',
              ))
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyFilledButton(
                  onPressed: () => widget.controller.deleteMember(),
                  isLoading: widget.controller.isDeleting.value,
                  color: error,
                  child: Row(
                    children: [
                      Text('global_delete'.tr),
                      const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
