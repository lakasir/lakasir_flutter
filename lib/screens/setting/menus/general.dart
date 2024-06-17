import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/select_input_feld.dart';

class GeneralSetting extends StatefulWidget {
  final AuthController authController;
  const GeneralSetting({
    super.key,
    required this.authController,
  });

  @override
  State<GeneralSetting> createState() => _GeneralSettingState();
}

class _GeneralSettingState extends State<GeneralSetting> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("setting_general".tr, style: const TextStyle(fontSize: 20)),
        if (can(widget.authController.permissions, 'read category'))
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
                  Icons.category_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              list: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("setting_category".tr,
                        style: const TextStyle(fontSize: 20)),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
        if (can(widget.authController.permissions, 'update currency'))
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
                          Option(
                            name: "OMR",
                            value: "OMR",
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
      ],
    );
  }
}
