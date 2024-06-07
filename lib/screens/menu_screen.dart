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

          return LayoutBuilder(
            builder: (context, constraints) {
              bool isTablet = constraints.maxWidth > 600;

              if (isTablet) {
                return GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: menus.length,
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
                        margin: const EdgeInsets.all(10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () =>
                                Get.toNamed(menus[index]['route'] as String),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: const BoxDecoration(
                                      color: primary,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: menus[index]['icon'] as Widget,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    menus[index]['title'] as String,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    menus[index]['subtitle'] as String,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                var height = MediaQuery.of(context).size.height;

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
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () =>
                                Get.toNamed(menus[index]['route'] as String),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: const BoxDecoration(
                                      color: primary,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: menus[index]['icon'] as Widget,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          menus[index]['title'] as String,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          menus[index]['subtitle'] as String,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
