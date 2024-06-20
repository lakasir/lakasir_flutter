import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class TransactionMenuScreen extends StatefulWidget {
  const TransactionMenuScreen({super.key});
  @override
  State<TransactionMenuScreen> createState() => _TransactionMenuScreenState();
}

class _TransactionMenuScreenState extends State<TransactionMenuScreen> {
  var menus = [
    {
      'title': 'transaction_cashier'.tr,
      'icon': Icons.trending_up,
      'route': '/menu/transaction/cashier',
      'permission': 'create selling',
    },
    {
      'title': 'PPOB',
      'icon': Icons.food_bank_rounded,
      'route': '/menu/transaction/ppob',
      'permission': 'read ppob',
    },
    {
      'title': 'transaction_history'.tr,
      'icon': Icons.list_rounded,
      'route': '/menu/transaction/history',
      'permission': 'read selling',
    },
    {
      'title': 'transaction_cashier_report'.tr,
      'icon': Icons.note,
      'route': '/menu/transaction/reports/cashier',
      'permission': 'generate cashier report',
    },
  ];

  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Layout(
      title: 'menu_transaction'.tr,
      child: ListView.separated(
        itemCount: menus.length,
        separatorBuilder: (context, index) {
          return const SizedBox();
        },
        itemBuilder: (context, index) {
          var visible = (['/menu/setting', '/menu/profile']
                  .contains(menus[index]['route'])) ||
              (menus[index]['permission'] != null &&
                  can(
                    _authController.permissions,
                    ability: menus[index]['permission'] as String,
                  ));

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
                ],
                imagebox: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Icon(
                    menus[index]['icon'] as IconData,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
