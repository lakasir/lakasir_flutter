import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/requests/member_request.dart';
import 'package:lakasir/api/responses/members/member_response.dart';
import 'package:lakasir/services/member_service.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/text_field.dart';

class MemberController extends GetxController {
  final MemberService _memberService = MemberService();
  RxList<MemberResponse> members = <MemberResponse>[].obs;
  final isFetching = false.obs;
  final searchByNameController = TextEditingController();

  Future<void> fetchMembers() async {
    isFetching(true);
    final response = await _memberService.get(MemberRequest());
    members.assignAll(response);
    isFetching(false);
  }

  Future<void> searchMember() async {
    isFetching(true);
    final response = await _memberService.get(
      MemberRequest(
        name: searchByNameController.text,
      ),
    );
    members.assignAll(response);
    isFetching(false);
  }

  void showDialogSearch() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return MyDialog(
          noPadding: true,
          content: Column(
            children: [
              MyTextField(
                hintText: 'field_name'.tr,
                controller: searchByNameController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  searchMember();
                },
                rightIcon: IconButton(
                  onPressed: searchMember,
                  icon: const Icon(Icons.search),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    fetchMembers();
  }
}
