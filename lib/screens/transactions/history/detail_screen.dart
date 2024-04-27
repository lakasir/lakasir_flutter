import 'dart:io';
import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/controllers/settings/print_controller.dart';
import 'package:lakasir/screens/setting/printers/print_receipt.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/detail_transaction.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen({super.key});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  ScreenshotController ssController = ScreenshotController();
  TransactionHistoryResponse history = Get.arguments;
  bool sharedLoading = false;
  final PrintController _printerController = Get.put(PrintController());

  void rePrint() {
    if (_printerController.printers.isNotEmpty) {
      var printer = _printerController.printers.first;
      BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
      bluetooth.isConnected.then((value) {
        if (value!) {
          PrintReceipt(bluetooth: bluetooth).print(
            history,
            printer,
            copy: true,
          );
        } else {
          var device = BluetoothDevice(printer.name, printer.address);
          bluetooth.connect(device).then((value) {
            if (value) {
              PrintReceipt(bluetooth: bluetooth).print(
                history,
                printer,
                copy: true,
              );
            }
          });
        }
      });
    }
  }

  void captureAndShareWidget() {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    ssController
        .captureFromWidget(
      Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        color: Colors.grey[100],
        child: Column(
          children: [
            Text(
              "transaction_detail".tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            _detailTransaction(),
          ],
        ),
      ),
      pixelRatio: pixelRatio,
    )
        .then((
      Uint8List? image,
    ) async {
      setState(() {
        sharedLoading = true;
      });
      Directory tempDir = await getTemporaryDirectory();
      String directory = tempDir.path;
      File file = File('$directory/receipt.png');
      file.writeAsBytesSync(image!);

      shareImage(file.path);
      setState(() {
        sharedLoading = false;
      });
    });
  }

  Future<void> shareImage(String path) async {
    try {
      await Share.shareXFiles(
        [XFile(path)],
        text: history.code,
      );
    } catch (e) {
      debugPrint('Error sharing image: $e');
    }
  }

  DetailTransaction _detailTransaction() {
    return DetailTransaction(
      cashierName: history.cashier == null
          ? "global_no_item".trParams(
              {"item": "field_cashier".tr},
            )
          : history.cashier!.name,
      sellingCode: history.code,
      date: DateFormat('dd-MM-yyyy HH:mm')
          .format(DateTime.parse(history.createdAt!).toLocal())
          .toString(),
      memberName: history.member == null
          ? "global_no_item".trParams(
              {"item": "menu_member".tr},
            )
          : history.member!.name,
      paymentMethod: history.paymentMethod!.name,
      customerNumber: history.customerNumber == null
          ? "global_no_item".trParams(
              {"item": "field_customer_number".tr},
            )
          : history.customerNumber.toString(),
      cartItems: history.sellingDetails!
          .map(
            (e) => DetailTransactionItem(
              productName: e.product!.name,
              quantity: "${e.quantity} x ${formatPrice(e.price / e.quantity)}",
              subTotal: formatPrice(e.price),
            ),
          )
          .toList(),
      tax: "${history.tax!}%",
      subTotal: "sub",
      total: formatPrice(history.totalPrice!),
      payedMoney: formatPrice(history.payedMoney!),
      change: formatPrice(history.moneyChange!),
      note: history.note,
      actions: const [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "transaction_detail".tr,
      child: ListView(
        children: [
          _detailTransaction(),
          const SizedBox(height: 20),
          Row(
            children: [
              Flexible(
                child: MyFilledButton(
                  color: grey,
                  isLoading: sharedLoading,
                  onPressed: captureAndShareWidget,
                  child: Row(
                    children: [
                      Text("share".tr),
                      const SizedBox(width: 10),
                      const Icon(Icons.share),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: MyFilledButton(
                  onPressed: rePrint,
                  child: Row(
                    children: [
                      Text("re-print".tr),
                      const SizedBox(width: 10),
                      const Icon(Icons.print),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
