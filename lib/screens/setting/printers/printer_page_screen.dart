import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:isar/isar.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/models/printer.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class PrinterPageScreen extends StatefulWidget {
  const PrinterPageScreen({super.key});

  @override
  State<PrinterPageScreen> createState() => _PrinterPageScreenState();
}

class _PrinterPageScreenState extends State<PrinterPageScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  List<Printer> printers = [];
  @override
  void initState() {
    super.initState();
    fetchPrinters();
  }

  void fetchPrinters() async {
    var results = await LakasirDatabase().fetchPrinters();

    setState(() {
      printers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'setting_menu_printer'.tr,
      bottomNavigationBar: MyBottomBar(
        label: Text('global_add_item'.trParams({
          'item': 'setting_menu_printer'.tr,
        })),
        onPressed: () {
          Get.toNamed('/menu/setting/print/add');
        },
      ),
      child: printers.isEmpty
          ? Center(
              child: Text('global_no_item'.trParams({
                'item': 'setting_menu_printer'.tr,
              })),
            )
          : ListView.builder(
              itemCount: printers.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: MyCardList(
                    enableFeedback: false,
                    imagebox: const HeroIcon(
                      HeroIcons.printer,
                      size: 40,
                    ),
                    list: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                printers[index].name!,
                              ),
                              Text(
                                printers[index].address!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Get.dialog(
                                AlertDialog(
                                  title: Text('global_delete_item'.trParams({
                                    'item': 'setting_menu_printer'.tr,
                                  })),
                                  content: Text(
                                      'global_delete_item_content'.trParams({
                                    'item': 'setting_menu_printer'.tr,
                                  })),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('global_cancel'.tr),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await LakasirDatabase()
                                            .deletePrinters(printers[index]);
                                        Get.back();
                                        show(
                                          'global_deleted_item'.trParams({
                                            'item': 'setting_menu_printer'.tr,
                                          }),
                                          color: success,
                                        );
                                      },
                                      child: Text('global_delete'.tr),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const HeroIcon(
                              HeroIcons.trash,
                              color: error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
