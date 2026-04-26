import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/requests/member_request.dart';
import 'package:lakasir/offline/models/offline_member_model.dart';
import 'package:lakasir/offline/repositories/member_repository.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/text_field.dart';

class MemberController extends GetxController {
  final MemberRepository _memberRepository = MemberRepository();
  RxList<OfflineMember> members = <OfflineMember>[].obs;
  final isFetching = false.obs;
  final searchByNameController = TextEditingController();

  Future<void> fetchMembers() async {
    isFetching(true);
    members.assignAll(await _memberRepository.getMembers());
    isFetching(false);
  }

  Future<void> searchMember() async {
    isFetching(true);
    members.assignAll(await _memberRepository.getMembers(
      request: MemberRequest(name: searchByNameController.text),
    ));
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