import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/select_input_feld.dart';

class SystemSetting extends StatelessWidget {
  const SystemSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          child:
              Text("setting_system".tr, style: const TextStyle(fontSize: 20)),
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
                Icons.flag_outlined,
                color: Colors.white,
                size: 32,
              ),
            ),
            list: [
              Text("setting_language".tr, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
        // Container(
        //   margin: const EdgeInsets.only(top: 15),
        //   child: MyCardList(
        //     onTap: () {
        //       Get.dialog(AlertDialog(
        //         title: Text("setting_dark_mode".tr),
        //         content: Text("global_comming_soon".tr),
        //         actions: [
        //           TextButton(
        //             onPressed: () {
        //               Get.back();
        //             },
        //             child: Text("global_ok".tr),
        //           ),
        //         ],
        //       ));
        //     },
        //     imagebox: Container(
        //       width: 52,
        //       height: 52,
        //       decoration: const BoxDecoration(
        //         color: primary,
        //         borderRadius: BorderRadius.all(
        //           Radius.circular(10),
        //         ),
        //       ),
        //       child: const Icon(
        //         Icons.app_registration_rounded,
        //         color: Colors.white,
        //         size: 32,
        //       ),
        //     ),
        //     list: [
        //       Text("setting_dark_mode".tr,
        //           style: const TextStyle(fontSize: 20)),
        //     ],
        //   ),
        // ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: MyCardList(
            route: "/menu/setting/layout",
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
                Icons.dashboard_outlined,
                color: Colors.white,
                size: 32,
              ),
            ),
            list: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Layout".tr, style: const TextStyle(fontSize: 20)),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
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
              child: const HeroIcon(
                HeroIcons.printer,
                color: Colors.white,
                size: 32,
              ),
            ),
            list: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Print".tr, style: const TextStyle(fontSize: 20)),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
