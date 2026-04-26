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

class MemberAddController extends GetxController {
  final MemberController _memberController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final MemberRepository _memberRepository = MemberRepository();
  final memberNameController = TextEditingController();
  final memberCodeController = TextEditingController();
  final memberEmailOrPhoneController = TextEditingController();
  final memberAddressController = TextEditingController();
  final isSubmitting = false.obs;
  Rx<MemberErrorResponse> memberErrorResponse = MemberErrorResponse(
    name: "",
  ).obs;

  Future<void> addMember() async {
    try {
      isSubmitting(true);
      if (!formKey.currentState!.validate()) {
        isSubmitting(false);
        return;
      }
      await _memberRepository.createMember(
        OfflineMember()
          ..name = memberNameController.text
          ..code = memberCodeController.text.isEmpty ? null : memberCodeController.text
          ..email = memberEmailOrPhoneController.text.isEmpty ? null : memberEmailOrPhoneController.text
          ..address = memberAddressController.text.isEmpty ? null : memberAddressController.text
          ..isLocal = true,
      );
      Get.back();
      Get.rawSnackbar(
        message: "global_added_item".trParams({
          'item': 'menu_member'.tr,
        }),
        backgroundColor: success,
      );
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

  void clear() {
    memberNameController.clear();
    memberCodeController.clear();
    memberEmailOrPhoneController.clear();
    memberAddressController.clear();
    memberErrorResponse(
      MemberErrorResponse(
        name: "",
        email: "",
      ),
    );
  }
}