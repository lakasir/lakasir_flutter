import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class ProductSetting extends StatelessWidget {
  const ProductSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text("menu_product".tr, style: const TextStyle(fontSize: 20)),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: MyCardList(
            onTap: () {
              Get.toNamed("/menu/setting/hide_initial_price");
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
                HeroIcons.eyeSlash,
                color: Colors.white,
                size: 32,
              ),
            ),
            list: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "setting_secure_initial_price".tr,
                    style: const TextStyle(fontSize: 20),
                  ),
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
