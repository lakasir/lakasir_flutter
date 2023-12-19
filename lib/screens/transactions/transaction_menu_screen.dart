import 'package:flutter/material.dart';
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
      'title': 'Cashier',
      'icon': Icons.shopping_basket_rounded,
      'route': '/menu/transaction/cashier',
    },
    {
      'title': 'PPOB',
      'icon': Icons.food_bank_rounded,
      'route': '/menu/transaction/ppob',
    },
    {
      'title': 'History',
      'icon': Icons.list_rounded,
      'route': '/menu/transaction/history',
    },
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Layout(
      title: 'Transaction',
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
