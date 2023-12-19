import 'package:flutter/material.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Setting',
      child: ListView.separated(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("General", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 19),
              MyCardList(
                route: "/menu/setting/category",
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
                    Icons.category,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                list: const [
                  Text("Category", style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 19),
              MyCardList(
                route: "/menu/setting/currency",
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
                    Icons.attach_money_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                list: const [
                  Text("Currency", style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 19),
              const Text("System", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 19),
              MyCardList(
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
                    Icons.flag_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                list: const [
                  Text("Language", style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 19),
              MyCardList(
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
                    Icons.app_registration_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                list: const [
                  Text("Dark Mode", style: TextStyle(fontSize: 20)),
                ],
              ),
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
