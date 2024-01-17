import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/services/setting_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/select_input_feld.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SettingController settingController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'setting'.tr,
      child: ListView.separated(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("setting_general".tr, style: const TextStyle(fontSize: 20)),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: MyCardList(
                  route: "/menu/setting/category",
                  imagebox: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Icon(
                      Icons.category,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  list: [
                    Text("setting_category".tr,
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: MyCardList(
                  onTap: () {
                    var currencyController = SelectInputWidgetController();
                    currencyController.selectedOption = "IDR";
                    Get.dialog(MyDialog(
                      content: Column(
                        children: [
                          SelectInputWidget(
                            controller: currencyController,
                            label: "setting_currency".tr,
                            options: [
                              Option(
                                name: "IDR",
                                value: "IDR",
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          MyFilledButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("global_save".tr),
                          ),
                        ],
                      ),
                    ));
                  },
                  imagebox: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Icon(
                      Icons.attach_money_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  list: [
                    Text("setting_currency".tr,
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text("setting_system".tr,
                    style: const TextStyle(fontSize: 20)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: MyCardList(
                  onTap: () async {
                    var languageController = SelectInputWidgetController();
                    languageController.selectedOption = await getLanguageCode();
                    Get.dialog(MyDialog(
                      content: Column(
                        children: [
                          SelectInputWidget(
                            controller: languageController,
                            label: "setting_language".tr,
                            options: [
                              Option(
                                name: "English",
                                value: "en_US",
                              ),
                              Option(
                                name: "Indonesia",
                                value: "id_ID",
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          MyFilledButton(
                            onPressed: () async {
                              setLocale(languageController.selectedOption!);
                              await Get.forceAppUpdate();
                              // Get.updateLocale(Locale(languageController.selectedOption!));
                              Get.back();
                              Get.rawSnackbar(
                                message: "setting_language_success".tr,
                                backgroundColor: success,
                              );
                            },
                            child: Text("global_save".tr),
                          ),
                        ],
                      ),
                    ));
                  },
                  imagebox: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Icon(
                      Icons.flag_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  list: [
                    Text("setting_language".tr,
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: MyCardList(
                  onTap: () {
                    Get.dialog(AlertDialog(
                      title: Text("setting_dark_mode".tr),
                      content: Text("global_comming_soon".tr),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("global_ok".tr),
                        ),
                      ],
                    ));
                  },
                  imagebox: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Icon(
                      Icons.app_registration_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  list: [
                    Text("setting_dark_mode".tr,
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text("menu_transaction".tr,
                    style: const TextStyle(fontSize: 20)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: MyCardList(
                  imagebox: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Icon(
                      Icons.money_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  list: [
                    Text("cashier_cash_drawer".tr,
                        style: const TextStyle(fontSize: 20)),
                  ],
                  trailing: Obx(
                    () {
                      var cashDrawerEnabled = settingController.setting.value.cashDrawerEnabled;
                      return SizedBox(
                      width: Get.width * 0.47,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Switch(
                          focusColor: primary,
                          value: cashDrawerEnabled,
                          onChanged: (value) {
                            Get.dialog(AlertDialog(
                              title: Text("global_warning".tr),
                              content: Text(cashDrawerEnabled
                                  ? "cashier_cash_drawer_question_deactivate".tr
                                  : "cashier_cash_drawer_question_activate".tr),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("global_cancel".tr),
                                ),
                                TextButton(
                                  onPressed: () {
                                    settingController.updateSetting(
                                      "cash_drawer_enabled",
                                      value,
                                    );
                                    Get.back();
                                  },
                                  child: Text("global_ok".tr),
                                ),
                              ],
                            ));
                          },
                        ),
                      ),
                    );
                    },
                  ),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
