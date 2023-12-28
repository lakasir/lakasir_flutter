import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/requests/about_request.dart';
import 'package:lakasir/api/responses/abouts/about_response.dart';
import 'package:lakasir/controllers/abouts/about_controller.dart';
import 'package:lakasir/services/about_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/select_input_feld.dart';

class AboutEditController extends GetxController {
  AboutController aboutController = Get.find();
  RxBool isLoading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameInputController = TextEditingController();
  final SelectInputWidgetController businessTypeInputController =
      SelectInputWidgetController();
  final TextEditingController locationInputController = TextEditingController();
  final TextEditingController ownerNameInputController =
      TextEditingController();
  final SelectInputWidgetController currencyInputController =
      SelectInputWidgetController();
  final Rx<AboutResponse> about = AboutResponse().obs;
  final AboutService _aboutService = AboutService();

  Future<void> updateAbout() async {
    try {
      isLoading(true);
      await _aboutService.update(
        AboutRequest(
          shopName: nameInputController.text,
          businessType: businessTypeInputController.selectedOption,
          ownerName: ownerNameInputController.text,
          shopLocation: locationInputController.text,
          photoUrl: about.value.photo,
        ),
      );
      await aboutController.getShop();
      about.value = aboutController.shop.value;
      Get.back();
      Get.rawSnackbar(
        message: 'About Updated',
        backgroundColor: success,
      );
      isLoading(false);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setData() {
    about.value = Get.arguments as AboutResponse;

    nameInputController.text = about.value.shopeName ?? "";
    businessTypeInputController.selectedOption = about.value.businessType ?? "";
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
