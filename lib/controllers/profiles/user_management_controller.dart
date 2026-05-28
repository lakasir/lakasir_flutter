import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/responses/auths/profile_response.dart';
import 'package:lakasir/services/profile_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';

class UserManagementController extends GetxController {
  final ProfileService _profileService = ProfileService();
  RxList<ProfileResponse> users = <ProfileResponse>[].obs;
  RxBool isLoading = false.obs;
  RxBool isDeleting = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> fetchUsers() async {
    isLoading(true);
    try {
      users.value = await _profileService.getUsers();
    } catch (e) {
      show(e.toString(), color: Colors.red);
    }
    isLoading(false);
  }

  Future<void> deleteUser(int id) async {
    isDeleting(true);
    try {
      await _profileService.deleteUser(id);
      users.removeWhere((user) => user.id == id);
      show(
        'global_deleted_item'.trParams({
          'item': 'User',
        }),
        color: success,
      );
    } on ValidationException catch (e) {
      show(e.toString(), color: Colors.red);
    } catch (e) {
      show(
        'global_failed_delete_item'.trParams({
          'item': 'User',
        }),
        color: Colors.red,
      );
    }
    isDeleting(false);
  }

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }
}
