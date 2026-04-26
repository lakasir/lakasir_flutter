import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class SystemSetting extends StatefulWidget {
  const SystemSetting({
    super.key,
  });

  @override
  State<SystemSetting> createState() => _SystemSettingState();
}

class _SystemSettingState extends State<SystemSetting> {
  final AuthController _authController = Get.put(AuthController());
  final AppModeService _appModeService = Get.find<AppModeService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final showConnectServer = !_appModeService.isOnline;
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: Text(
            "setting_system".tr,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        if (_authController.feature(feature: 'product-stock'))
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: MyCardList(
              route: '/menu/setting/notification',
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
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              list: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "menu_notification".tr,
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
            route: '/menu/setting/print',
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
        if (showConnectServer)
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: MyCardList(
              route: '/settings/connect-server',
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
                  Icons.cloud_upload_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              list: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('connect_to_server'.tr, style: const TextStyle(fontSize: 20)),
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
    });
  }
}
