import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/confirm_dialog.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class AuthSetting extends StatelessWidget {
  const AuthSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text("auth".tr, style: const TextStyle(fontSize: 20)),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: MyCardList(
            onTap: () {
              Get.toNamed("/forgot");
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
              child: const HeroIcon(
                HeroIcons.key,
                color: Colors.white,
                size: 32,
              ),
            ),
            list: [
              Text(
                "forgot_password".tr,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15, bottom: 20),
          child: MyCardList(
            onTap: () {
              Get.dialog(MyConfirmDialog(
                title: "global_warning".tr,
                content: Text("logout_question".tr),
                onConfirm: () {
                  Get.back();
                  logout().then((value) {
                    Get.offAllNamed('/auth');
                  });
                },
                confirmText: "global_ok".tr,
              ));
            },
            imagebox: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: error,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: const HeroIcon(
                HeroIcons.power,
                color: Colors.white,
                size: 32,
              ),
            ),
            list: [
              Text(
                "logout".tr,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
