import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/api/responses/members/member_error_response.dart';
import 'package:lakasir/controllers/members/member_controller.dart';
import 'package:lakasir/offline/models/offline_member_model.dart';
import 'package:lakasir/offline/repositories/member_repository.dart';
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
  final MemberRepository _memberRepository = MemberRepository();
  final Rx<OfflineMember> member = OfflineMember().obs;
  Rx<MemberErrorResponse> memberErrorResponse = MemberErrorResponse(
    name: "",
  ).obs;

  Future<void> updateMember() async {
    if (isSubmitting.value) return;

    try {
      isSubmitting(true);
      if (!formKey.currentState!.validate()) {
        isSubmitting(false);
        return;
      }
      await _memberRepository.updateMember(
        OfflineMember()
          ..id = member.value.id
          ..remoteId = member.value.remoteId
          ..name = memberNameController.text
          ..code = memberCodeController.text.isEmpty ? null : memberCodeController.text
          ..email = memberEmailOrPhoneController.text.isEmpty ? null : memberEmailOrPhoneController.text
          ..address = memberAddressController.text.isEmpty ? null : memberAddressController.text
          ..isLocal = member.value.isLocal,
      );
      _memberController.fetchMembers();
      isSubmitting(false);
      show("global_updated_item".trParams({
        'item': 'menu_member'.tr,
      }));
      Get.until((route) => route.settings.name == '/menu/member');
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
        show(errorResponse.message, color: error);
      } else {
        debugPrint('Unexpected error during member update: $e');
        show('global_error_occurred'.tr, color: error);
      }
    }
  }

  Future<void> deleteMember() async {
    if (isDeleting.value) return;

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
                  await _memberRepository.deleteMember(member.value.id);
                  _memberController.fetchMembers();
                  isDeleting(false);
                  show("global_deleted_item".trParams({
                    'item': 'menu_member'.tr,
                  }));
                  Get.until((route) => route.settings.name == '/menu/member');
                } catch (e) {
                  isDeleting(false);
                  if (e is ValidationException) {
                    show('global_error_occurred'.tr, color: error);
                  } else {
                    show(
                      "${'global_failed_delete_item'.trParams({'item': 'menu_member'.tr.toLowerCase()})}: ${'has_an_item'.trParams({'item': 'menu_transaction'.tr.toLowerCase()})}",
                      color: error,
                    );
                  }
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
    member.value = Get.arguments as OfflineMember;
    memberNameController.text = member.value.name;
    memberCodeController.text = member.value.code ?? '';
    memberEmailOrPhoneController.text = member.value.email ?? '';
    memberAddressController.text = member.value.address ?? '';

    memberErrorResponse(
      MemberErrorResponse(
        name: "",
        email: "",
      ),
    );
  }
}