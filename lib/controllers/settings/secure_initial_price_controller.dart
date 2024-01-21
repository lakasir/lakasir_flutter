import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/services/secure_initial_price_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/text_field.dart';

class SecureInitialPriceController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final formKeyVerify = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  final isOpened = false.obs;
  final SecureInitialPriceService _secureInitialPriceService =
      SecureInitialPriceService();
  final _settingController = Get.put(SettingController());
  TextEditingController passwordController = TextEditingController();
  final passwordError = ''.obs;

  void updatePassword() {
    if (!formKey.currentState!.validate()) {
      debugPrint('error');
      isLoading(false);
      return;
    }
  }

  void verifyPassword({ bool isDisableSetting = false }) {
    passwordError('');
    passwordController.text = '';
    Get.dialog(
      MyDialog(
        content: Form(
          key: formKeyVerify,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Obx(
                  () => MyTextField(
                    mandatory: true,
                    controller: passwordController,
                    label: 'field_password'.tr,
                    obscureText: true,
                    errorText: passwordError.value,
                    keyboardType:
                        _settingController.setting.value.hideInitialPriceUsingPin!
                            ? TextInputType.number
                            : TextInputType.text,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: MyFilledButton(
                  onPressed: () async {
                    try {
                      isLoading(true);
                      await _secureInitialPriceService.verifyPassword(
                        passwordController.text,
                      );
                      if (isDisableSetting) {
                        _settingController.updateSetting(
                          'secure_initial_price_enabled',
                          false,
                        );
                      }
                      isOpened(true);
                      isLoading(false);
                      Get.back();
                    } catch (e) {
                      if (e is ValidationException) {
                        ErrorResponse errorResponse = ErrorResponse.fromJson(
                          jsonDecode(e.toString()),
                          null,
                        );
                        passwordError(errorResponse.message);
                        Get.rawSnackbar(
                          message: errorResponse.message,
                          backgroundColor: error,
                        );
                      }
                    }
                  },
                  child: Text('global_verify'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
