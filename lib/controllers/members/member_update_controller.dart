import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/requests/member_request.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/api/responses/members/member_error_response.dart';
import 'package:lakasir/api/responses/members/member_response.dart';
import 'package:lakasir/controllers/members/member_controller.dart';
import 'package:lakasir/services/member_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';

class MemberUpdateController extends GetxController {
  final MemberController _memberController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final memberNameController = TextEditingController();
  final memberCodeController = TextEditingController();
  final memberEmailOrPhoneController = TextEditingController();
  final memberAddressController = TextEditingController();
  final isSubmitting = false.obs;
  final isDeleting = false.obs;
  final MemberService _memberService = MemberService();
  final Rx<MemberResponse> member = MemberResponse(
    id: 0,
    name: '',
    code: '',
    email: '',
    address: '',
    updatedAt: '',
    createdAt: '',
  ).obs;
  Rx<MemberErrorResponse> memberErrorResponse = MemberErrorResponse(
    name: "",
  ).obs;

  Future<void> updateMember() async {
    try {
      isSubmitting(true);
      if (!formKey.currentState!.validate()) {
        isSubmitting(false);
        return;
      }
      await _memberService.update(
        member.value.id,
        MemberRequest(
          name: memberNameController.text,
          code: memberCodeController.text,
          email: memberEmailOrPhoneController.text,
          address: memberAddressController.text,
        ),
      );
      Get.back();
      show("global_updated_item".trParams({
        'item': 'menu_member'.tr,
      }), color: success);
      isSubmitting(false);
      _memberController.fetchMembers();
    } catch (e) {
      isSubmitting(false);
      if (e is ValidationException) {
        ErrorResponse<MemberErrorResponse> errorResponse =
            ErrorResponse.fromJson(
          jsonDecode(
            e.toString(),
          ),
          (json) => MemberErrorResponse.fromJson(json),
        );
        memberErrorResponse(errorResponse.errors);
      }
    }
  }

  Future<void> deleteMember() async {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text('global_sure?'.tr),
          content: Text('global_sure_content'.trParams({
            'item': 'menu_member'.tr,
          })),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('global_cancel'.tr),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                try {
                  isDeleting(true);
                  await _memberService.delete(member.value.id);
                  Get.back();
                  show("global_deleted_item".trParams({
                    'item': 'menu_member'.tr,
                  }), color: success);
                  isDeleting(false);
                  _memberController.fetchMembers();
                } catch (e) {
                  isDeleting(false);
                  show('${'global_failed_delete_item'.trParams({'item': 'menu_member'.tr.toLowerCase()})} - ${'has_an_item'.trParams({'item': 'menu_transaction'.tr.toLowerCase()})}', color: error, duration: const Duration(seconds: 2));
                }
              },
              child: Text('global_yes'.tr),
            ),
          ],
        );
      },
    );
  }

  void setData() {
    member.value = Get.arguments as MemberResponse;
    memberNameController.text = member.value.name;
    memberCodeController.text = member.value.code!;
    memberEmailOrPhoneController.text =
        member.value.email == null ? '' : member.value.email!;
    memberAddressController.text =
        member.value.address == null ? '' : member.value.address!;

    memberErrorResponse(
      MemberErrorResponse(
        name: "",
        email: "",
      ),
    );
  }
}
