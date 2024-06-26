import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lakasir/api/requests/pagination_request.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/controllers/settings/print_controller.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/controllers/transactions/history_controller.dart';
import 'package:lakasir/screens/setting/printers/print_receipt.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({
    super.key,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  final PrintController _printerController = Get.put(PrintController());
  final ProductController _productController = Get.put(ProductController());
  final HistoryController _transactionController = Get.put(HistoryController());
  final CartController _cartController = Get.put(CartController());
  bool copy = false;
  double changes = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      changes = Get.arguments as double;
    });
  }

  void refreshCashier() {
    _productController.getProducts();
    _transactionController.fetchTransaction(
      PaginationRequest(
        page: 1,
        perPage: _transactionController.perPage,
      ),
    );
    _cartController.cartSessions.value = CartSession(
      cartItems: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) async {},
      child: Layout(
        noAppBar: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HeroIcon(
              HeroIcons.checkCircle,
              size: 150,
              color: success,
            ),
            const SizedBox(height: 10),
            Text("payment_success".tr),
            Text(
              "${"field_change".tr} = ${formatPrice(changes, isSymbol: false)}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              width: 200,
              margin: const EdgeInsets.only(bottom: 10, top: 10),
              child: MyFilledButton(
                isLoading: isLoading,
                onPressed: () {
                  refreshCashier();
                  if (_printerController.printers.isNotEmpty) {
                    var printer = _printerController.printers.first;
                    BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
                    bluetooth.isConnected.then((value) {
                      if (value!) {
                        PrintReceipt(bluetooth: bluetooth).print(
                          _transactionController.transaction.value,
                          printer,
                          copy: copy,
                        );
                      } else {
                        var device =
                            BluetoothDevice(printer.name, printer.address);
                        bluetooth.connect(device).then((value) {
                          if (value) {
                            PrintReceipt(bluetooth: bluetooth).print(
                              _transactionController.transaction.value,
                              printer,
                              copy: copy,
                            );
                          }
                        });
                      }
                      setState(() {
                        copy = true;
                      });
                    }).catchError((value) {
                      show("printer_error".tr, color: error);
                    });
                  } else {
                    show("setup_the_printer".tr, color: error);
                    // Get.toNamed('/menu/setting/print/add');
                  }
                },
                child: Row(
                  children: [
                    const HeroIcon(HeroIcons.printer),
                    const SizedBox(width: 10),
                    Text("print_invoice".tr),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: MyFilledButton(
                color: grey,
                onPressed: () {
                  refreshCashier();
                  Get.back();
                },
                child: Row(
                  children: [
                    Text(
                      "global_back".tr,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
