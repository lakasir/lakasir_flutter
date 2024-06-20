import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';

class SettingNotificationScreen extends StatefulWidget {
  const SettingNotificationScreen({super.key});

  @override
  State<SettingNotificationScreen> createState() =>
      _SettingNotificationScreenState();
}

class _SettingNotificationScreenState extends State<SettingNotificationScreen> {
  String? minStockNotification = "0";
  final AuthController _authController = Get.put(AuthController());
  final SettingController _settingController = Get.put(SettingController());

  @override
  void initState() {
    super.initState();
    setState(() {
      minStockNotification =
          _settingController.setting.value.minimumStock.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'menu_setting_notification'.tr,
      child: ListView(
        children: [
          if (can(
            _authController.permissions,
            ability: 'set the minimum stock notification',
          ))
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'set_the_min_stock_notification'.tr,
                  style: const TextStyle(fontSize: 20),
                ),
                Flexible(
                  child: DropdownButton(
                    value: minStockNotification,
                    items: const [
                      DropdownMenuItem(
                        value: '0',
                        child: Text('0'),
                      ),
                      DropdownMenuItem(
                        value: '5',
                        child: Text('5'),
                      ),
                      DropdownMenuItem(
                        value: '10',
                        child: Text('10'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        minStockNotification = value;
                      });
                      _settingController.updateSetting(
                        'minimum_stock_nofication',
                        value,
                      );
                      show('set_minimum_stock_nofication_success'.tr);
                    },
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
