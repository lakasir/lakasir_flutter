import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/controllers/settings/secure_initial_price_controller.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/layout.dart';

class HideInitialPriceScreen extends StatefulWidget {
  const HideInitialPriceScreen({super.key});

  @override
  State<HideInitialPriceScreen> createState() => _HideInitialPriceScreenState();
}

class _HideInitialPriceScreenState extends State<HideInitialPriceScreen> {
  final SettingController _settingController = Get.put(SettingController());
  final SecureInitialPriceController _secureInitialPriceController =
      Get.put(SecureInitialPriceController());

  @override
  void dispose() {
    _secureInitialPriceController.isOpened(false);
    _secureInitialPriceController.passwordError.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'setting_secure_initial_price'.tr,
      child: ListView(
        children: [
          Text(
            'setting_secure_initial_price_description'.tr,
            style: const TextStyle(fontSize: 16, color: error),
          ),
          const SizedBox(height: 10),
          Text(
            'setting_secure_initial_price_info'.tr,
            style: const TextStyle(fontSize: 16, color: error),
          ),
          const SizedBox(height: 10),
          Text(
            'setting_secure_feature_affected'.tr,
            style: const TextStyle(fontSize: 16, color: error),
          ),
          const SizedBox(height: 10),
          Obx(
            () {
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text('setting_secure_initial_price_enabled'.tr),
                trailing: Switch(
                  value: _settingController.setting.value.hideInitialPrice!,
                  onChanged: (value) {
                    if (!value) {
                      _secureInitialPriceController.verifyPassword(
                        isDisableSetting: true,
                      );
                      return;
                    }
                    _settingController.updateSetting(
                      'secure_initial_price_enabled',
                      value,
                    );
                  },
                ),
              );
            },
          ),
          // Obx(() {
          //   return Visibility(
          //     visible: _settingController.setting.value.hideInitialPrice!,
          //     child: Form(
          //       key: _secureInitialPriceController.formKey,
          //       child: Column(
          //         children: [
          //           Container(
          //             margin: const EdgeInsets.only(bottom: 10),
          //             child: ListTile(
          //               contentPadding: const EdgeInsets.all(0),
          //               title:
          //                   Text('setting_secure_initial_price_using_pin'.tr),
          //               trailing: Switch(
          //                 value: _settingController
          //                     .setting.value.hideInitialPriceUsingPin!,
          //                 onChanged: (value) {
          //                   _settingController.updateSetting(
          //                     'secure_initial_price_using_pin',
          //                     value,
          //                   );
          //                 },
          //               ),
          //             ),
          //           ),
          //           Container(
          //             margin: const EdgeInsets.only(bottom: 10),
          //             child: MyTextField(
          //               controller: TextEditingController(),
          //               label: 'field_old_password'.tr,
          //               info:
          //                   'setting_secure_initial_price_old_password_info'.tr,
          //               hintText: 'field_old_password'.tr,
          //               obscureText: true,
          //             ),
          //           ),
          //           Container(
          //             margin: const EdgeInsets.only(bottom: 10),
          //             child: MyTextField(
          //               mandatory: true,
          //               controller: TextEditingController(),
          //               label: 'field_password'.tr,
          //               obscureText: true,
          //               keyboardType: _settingController
          //                       .setting.value.hideInitialPriceUsingPin!
          //                   ? TextInputType.number
          //                   : TextInputType.text,
          //             ),
          //           ),
          //           Container(
          //             margin: const EdgeInsets.only(bottom: 10),
          //             child: MyTextField(
          //               mandatory: true,
          //               controller: TextEditingController(),
          //               label: 'field_password_confirmation'.tr,
          //               obscureText: true,
          //               keyboardType: _settingController
          //                       .setting.value.hideInitialPriceUsingPin!
          //                   ? TextInputType.number
          //                   : TextInputType.text,
          //             ),
          //           ),
          //           Container(
          //             margin: const EdgeInsets.only(top: 10),
          //             child: MyFilledButton(
          //               onPressed: () {
          //                 _secureInitialPriceController.updatePassword();
          //               },
          //               child: Text('global_save'.tr),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }
}
