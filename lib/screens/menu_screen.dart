import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/profiles/profile_controller.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var menus = [
    {
      'title': 'menu_transaction'.tr,
      'subtitle': 'menu_transaction_subtitle'.tr,
      'icon': const Icon(Icons.money, size: 50, color: Colors.white),
      'route': '/menu/transaction',
      'permission': 'read selling',
    },
    {
      'title': 'menu_product'.tr,
      'subtitle': 'menu_product_subtitle'.tr,
      'icon': const HeroIcon(
        HeroIcons.shoppingBag,
        size: 50,
        color: Colors.white,
        style: HeroIconStyle.solid,
      ),
      'route': '/menu/product',
      'permission': 'read product',
    },
    {
      'title': 'menu_member'.tr,
      'subtitle': 'menu_member_subtitle'.tr,
      'icon': const Icon(Icons.people, size: 50, color: Colors.white),
      'route': '/menu/member',
      'permission': 'read member',
    },
    {
      'title': 'menu_profile'.tr,
      'subtitle': 'menu_profile_subtitle'.tr,
      'icon': const Icon(Icons.person, size: 50, color: Colors.white),
      'route': '/menu/profile',
    },
    {
      'title': 'menu_about'.tr,
      'subtitle': 'menu_about_subtitle'.tr,
      'icon': const Icon(Icons.info, size: 50, color: Colors.white),
      'route': '/menu/about',
      'permission': 'read about',
    },
    {
      'title': 'menu_setting'.tr,
      'subtitle': 'menu_setting_subtitle'.tr,
      'icon': const Icon(Icons.settings, size: 50, color: Colors.white),
      'route': '/menu/setting',
    },
  ];

  SettingController settingController = Get.put(SettingController());
  final AuthController _authController = Get.put(AuthController());
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _authController.fetchPermissions();
  }

  @override
  void dispose() {
    super.dispose();
    _authController.fetchPermissions();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Layout(
      title: 'menu'.tr,
      child: Obx(
        () {
          if (_authController.loading.value &&
              _profileController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.separated(
            itemCount: menus.length,
            separatorBuilder: (context, index) {
              return Container();
            },
            itemBuilder: (context, index) {
              var visible = true;
              if (menus[index]['permission'] != null) {
                visible = can(
                  _authController.permissions,
                  menus[index]['permission'] as String,
                );
              }

              return Visibility(
                visible: visible,
                child: Container(
                  margin: EdgeInsets.only(bottom: height * 0.02),
                  child: MyCardList(
                    route: menus[index]['route'] as String,
                    list: [
                      Text(
                        menus[index]['title'] as String,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: Text(
                          menus[index]['subtitle'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ],
                    imagebox: Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: menus[index]['icon'] as Widget,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
