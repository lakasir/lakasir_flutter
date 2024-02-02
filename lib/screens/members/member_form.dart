import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/members/member_response.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/text_field.dart';

class MemberForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Obx(
              () => MyTextField(
                controller: controller.memberNameController,
                mandatory: true,
                label: 'field_name'.tr,
                errorText: controller.memberErrorResponse.value.name,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              controller: controller.memberCodeController,
              info: "info_leave_empty".tr,
              label: "field_code".tr,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Obx(
              () => MyTextField(
                controller: controller.memberEmailOrPhoneController,
                label: "field_email_or_phone".tr,
                errorText: controller.memberErrorResponse.value.email ?? "",
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: MyTextField(
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              controller: controller.memberAddressController,
              label: "field_address".tr,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Obx(
              () => MyFilledButton(
                onPressed: onPressed,
                isLoading: controller.isSubmitting.value,
                child: Text('global_save'.tr),
              ),
            ),
          ),
          if (isUpdate == true)
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyFilledButton(
                  onPressed: () => controller.deleteMember(),
                  isLoading: controller.isDeleting.value,
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
