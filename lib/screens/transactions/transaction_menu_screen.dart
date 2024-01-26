import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    },
    // {
    //   'title': 'PPOB',
    //   'icon': Icons.food_bank_rounded,
    //   'route': '/menu/transaction/ppob',
    // },
    {
      'title': 'transaction_history'.tr,
      'icon': Icons.list_rounded,
      'route': '/menu/transaction/history',
    },
    {
      'title': 'transaction_cashier_report'.tr,
      'icon': Icons.note,
      'route': '/menu/transaction/reports/cashier',
    },
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Layout(
      title: 'menu_transaction'.tr,
      child: ListView.separated(
        itemCount: menus.length,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: height * 2.7 / 100,
          );
        },
        itemBuilder: (context, index) {
          return MyCardList(
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
          );
        },
      ),
    );
  }
}
