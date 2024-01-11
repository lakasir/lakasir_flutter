import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

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
                onTap: () {
                  var currencyController = SelectInputWidgetController();
                  currencyController.selectedOption = "IDR";
                  Get.dialog(MyDialog(
                    content: Column(
                      children: [
                        SelectInputWidget(
                          controller: currencyController,
                          label: "Currency",
                          options: [
                            Option(
                              name: "IDR",
                              value: "IDR",
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        MyFilledButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  ));
                },
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
                onTap: () {
                  var languageController = SelectInputWidgetController();
                  languageController.selectedOption = "en";
                  Get.dialog(MyDialog(
                    content: Column(
                      children: [
                        SelectInputWidget(
                          controller: languageController,
                          label: "Language",
                          options: [
                            Option(
                              name: "English",
                              value: "en",
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        MyFilledButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  ));
                },
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
                onTap: () {
                  Get.dialog(AlertDialog(
                    title: const Text("Dark Mode"),
                    content: const Text("Coming Soon"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ));
                },
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
