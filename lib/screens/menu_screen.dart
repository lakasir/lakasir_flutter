import 'package:flutter/material.dart';
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
      'title': 'Transaction',
      'subtitle': 'Sell your product or service',
      'icon': Icons.money,
      'route': '/menu/transaction',
    },
    {
      'title': 'Product',
      'subtitle': 'Manage your product',
      'icon': Icons.food_bank_rounded,
      'route': '/menu/product',
    },
    {
      'title': 'Member',
      'subtitle': 'Member is a success key for your  bussiness',
      'icon': Icons.people,
      'route': '/menu/member',
    },
    {
      'title': 'Profile',
      'subtitle': 'Every person is has an iconic profile',
      'icon': Icons.person,
      'route': '/menu/profile',
    },
    {
      'title': 'About',
      'subtitle': 'Every bussiness is has an iconic purpose',
      'icon': Icons.info,
      'route': '/menu/about',
    },
    {
      'title': 'Setting',
      'subtitle': 'Lakasir is configurable',
      'icon': Icons.settings,
      'route': '/menu/setting',
    },
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Layout(
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
