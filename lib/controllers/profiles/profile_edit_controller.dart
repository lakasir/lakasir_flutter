import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/requests/profile_request.dart';
import 'package:lakasir/api/responses/auths/profile_error_response.dart';
import 'package:lakasir/api/responses/auths/profile_response.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/controllers/profiles/profile_controller.dart';
import 'package:lakasir/services/profile_service.dart';
import 'package:lakasir/widgets/select_input_feld.dart';

class ProfileEditController extends GetxController {
  TextEditingController nameInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController addressInputController = TextEditingController();
  SelectInputWidgetController languageController =
      SelectInputWidgetController();

  RxBool isLoading = false.obs;
  Rx<ProfileResponse> profile = ProfileResponse().obs;
  final ProfileService _profileService = ProfileService();
  final ProfileController _profileController = Get.find();
  final formKey = GlobalKey<FormState>();
  Rx<ProfileErrorResponse> profileErrorResponse = ProfileErrorResponse().obs;

  Future<void> updateProfile() async {
    try {
      isLoading(true);
      if (!formKey.currentState!.validate()) {
        isLoading(false);
        return;
      }
      await _profileService.update(ProfileRequest(
        name: nameInputController.text,
        phone: phoneInputController.text,
        email: emailInputController.text,
        address: addressInputController.text,
        locale: languageController.selectedOption,
        photoUrl: profile.value.photoUrl,
      ));
      clearError();
      await _profileController.getProfile();
      Get.back();
      Get.rawSnackbar(
        message: 'Profile Updated',
        backgroundColor: Colors.green,
      );
      isLoading(false);
    } catch (e) {
      print(e);
      isLoading(false);
      if (e is ValidationException) {
        ErrorResponse<ProfileErrorResponse> errorResponse =
            ErrorResponse.fromJson(
          jsonDecode(
            e.toString(),
          ),
          (json) {
            return ProfileErrorResponse.fromJson(json);
          },
        );
        profileErrorResponse(errorResponse.errors);
      }
    }
  }

  void clearError() {
    profileErrorResponse(
      ProfileErrorResponse(
        name: "",
        email: "",
        phone: "",
        address: "",
        photoUrl: "",
        locale: "",
      ),
    );
  }

  void setData() {
    profile.value = Get.arguments as ProfileResponse;

    nameInputController.text = profile.value.name ?? "";
    phoneInputController.text = profile.value.phone ?? "";
    emailInputController.text = profile.value.email ?? "";
    addressInputController.text = profile.value.address ?? "";
    languageController.selectedOption = profile.value.locale ?? "en";

    clearError();
  }

  @override
  void onInit() {
    super.onInit();
    setData();
  }
}
