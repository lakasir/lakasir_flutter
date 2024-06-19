import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lakasir/controllers/settings/print_controller.dart';
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
  final _printerController = Get.put(PrintController());

  @override
  void initState() {
    super.initState();
    fetchPrinters();
  }

  void fetchPrinters() async {
    _printerController.fetchPrinters();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Layout(
        title: 'setting_menu_printer'.tr,
        bottomNavigationBar: _printerController.printers.isEmpty
            ? MyBottomBar(
                label: Text('global_add_item'.trParams({
                  'item': 'setting_menu_printer'.tr,
                })),
                icon: Icons.add,
                onPressed: () {
                  Get.toNamed('/menu/setting/print/add');
                },
              )
            : null,
        child: Obx(
          () {
            if (_printerController.printers.isEmpty) {
              return Center(
                child: Text('global_no_item'.trParams({
                  'item': 'setting_menu_printer'.tr,
                })),
              );
            }

            return ListView.builder(
              itemCount: _printerController.printers.length,
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
                                _printerController.printers[index].name ?? "",
                              ),
                              Text('global_connected'.tr),
                              Text(
                                _printerController.printers[index].address ??
                                    "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              InkWell(
                                onTap: () async {
                                  var printer =
                                      _printerController.printers[index];
                                  BluetoothDevice device = BluetoothDevice(
                                    printer.name,
                                    printer.address,
                                  );
                                  BlueThermalPrinter bluetooth =
                                      BlueThermalPrinter.instance;
                                  bluetooth.isConnected.then((value) {
                                    if (!value!) {
                                      bluetooth.connect(device).then((value) {
                                        printExampleReceipt(bluetooth, printer);
                                      });
                                    } else {
                                      printExampleReceipt(bluetooth, printer);
                                    }
                                  });
                                },
                                child: const HeroIcon(
                                  HeroIcons.printer,
                                  color: primary,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.dialog(
                                    AlertDialog(
                                      title:
                                          Text('global_delete_item'.trParams({
                                        'item': 'setting_menu_printer'.tr,
                                      })),
                                      content: Text('global_delete_item_content'
                                          .trParams({
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
                                            var printer = _printerController
                                                .printers[index];
                                            await _printerController
                                                .deletePrinter(printer);
                                            BlueThermalPrinter bluetooth =
                                                BlueThermalPrinter.instance;
                                            bluetooth.disconnect();
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
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
