import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/screens/setting/menus/auth.dart';
import 'package:lakasir/screens/setting/menus/general.dart';
import 'package:lakasir/screens/setting/menus/product.dart';
import 'package:lakasir/screens/setting/menus/system.dart';
import 'package:lakasir/screens/setting/menus/transaction.dart';
import 'package:lakasir/widgets/layout.dart';

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
              const GeneralSetting(),
              const SystemSetting(),
              TransactionSetting(settingController: settingController),
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
