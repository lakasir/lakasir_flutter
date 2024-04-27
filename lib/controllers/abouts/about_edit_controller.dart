import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/requests/about_request.dart';
import 'package:lakasir/api/responses/abouts/about_error_response.dart';
import 'package:lakasir/api/responses/abouts/about_response.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/controllers/abouts/about_controller.dart';
import 'package:lakasir/services/about_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/select_input_feld.dart';

class AboutEditController extends GetxController {
  AboutController aboutController = Get.put(AboutController());
  RxBool isLoading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameInputController = TextEditingController();
  final SelectInputWidgetController businessTypeInput =
      SelectInputWidgetController();
  final TextEditingController locationInputController = TextEditingController();
  final TextEditingController ownerNameInputController =
      TextEditingController();
  final SelectInputWidgetController currencyInputController =
      SelectInputWidgetController();
  final TextEditingController otherBusinessType = TextEditingController();
  final Rx<AboutResponse> about = AboutResponse().obs;
  final AboutService _aboutService = AboutService();
  final Rx<AboutErrorResponse> aboutErrorResponse = AboutErrorResponse().obs;

  Future<void> updateAbout() async {
    try {
      isLoading(true);
      await _aboutService.update(
        AboutRequest(
          shopName: nameInputController.text,
          businessType: businessTypeInput.selectedOption,
          otherBusinessType: otherBusinessType.text,
          ownerName: ownerNameInputController.text,
          shopLocation: locationInputController.text,
          photoUrl: about.value.photo,
        ),
      );
      await aboutController.getShop();
      Get.back();
      Get.rawSnackbar(
        message: 'About Updated',
        backgroundColor: success,
      );
      isLoading(false);
      setData();
    } catch (e) {
      isLoading(false);
      debugPrint(e.toString());
      if (e is ValidationException) {
        ErrorResponse<AboutErrorResponse> errorResponses =
            ErrorResponse.fromJson(
          jsonDecode(
            e.toString(),
          ),
          (json) => AboutErrorResponse.fromJson(json),
        );
        aboutErrorResponse(errorResponses.errors);
      }
    }
  }

  void setData() {
    aboutErrorResponse(AboutErrorResponse());
    about.value = Get.arguments as AboutResponse;

    nameInputController.text = about.value.shopeName ?? "";
    businessTypeInput.selectedOption = about.value.businessType ?? "";
    otherBusinessType.text = about.value.otherBusinessType ?? "";
    locationInputController.text = about.value.location ?? "";
    ownerNameInputController.text = about.value.ownerName ?? "";
    currencyInputController.selectedOption = about.value.currency ?? "";
  }

  @override
  void onInit() {
    super.onInit();
    setData();
  }
}
