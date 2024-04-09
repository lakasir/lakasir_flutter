import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/screens/setting/menus/auth.dart';
import 'package:lakasir/screens/setting/menus/general.dart';
import 'package:lakasir/screens/setting/menus/product.dart';
import 'package:lakasir/screens/setting/menus/system.dart';
import 'package:lakasir/screens/setting/menus/transaction.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/widgets/layout.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SettingController settingController = Get.put(SettingController());
  final AuthController _authController = Get.put(AuthController());

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
              if (can(_authController.permissions, 'read category') ||
                  can(_authController.permissions, 'update currency'))
                GeneralSetting(authController: _authController),
              const SystemSetting(),
              if (can(_authController.permissions, 'enable cash drawer') ||
                  can(_authController.permissions, 'set default tax') ||
                  can(_authController.permissions, 'set selling method'))
                TransactionSetting(
                  settingController: settingController,
                  authController: _authController,
                ),
              if (can(
                  _authController.permissions, 'enable secure initial price'))
                const ProductSetting(),
              const AuthSetting(),
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
