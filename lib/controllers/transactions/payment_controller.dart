import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/requests/pagination_request.dart';
import 'package:lakasir/api/requests/payment_request.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/controllers/settings/print_controller.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/controllers/transactions/history_controller.dart';
import 'package:lakasir/models/printer.dart';
import 'package:lakasir/screens/setting/printers/print_receipt.dart';
import 'package:lakasir/services/payment_service.dart';
import 'package:lakasir/utils/colors.dart';

class PaymentController extends GetxController {
  final _productController = Get.put(ProductController());
  final _paymentService = PaymentSerivce();
  final _cartController = Get.put(CartController());
  final _transactionController = Get.put(HistoryController());
  final _printerController = Get.put(PrintController());
  final RxBool isLoading = false.obs;

  void store() async {
    try {
      isLoading(true);
      var transactionResponse = await _paymentService.store(PaymentRequest(
        payedMoney: _cartController.cartSessions.value.payedMoney,
        friendPrice: false,
        tax: _cartController.cartSessions.value.tax,
        memberId: _cartController.cartSessions.value.member?.id,
        products: _cartController.cartSessions.value.cartItems
            .map(
              (e) => PaymentRequestItem(
                productId: e.product.id,
                qty: e.qty,
              ),
            )
            .toList(),
      ));
      if (_printerController.printers.isNotEmpty) {
        var printer = _printerController.printers.first;
        BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
        bluetooth.isConnected.then((value) {
          if (value!) {
            PrintReceipt(bluetooth: bluetooth).print(
              transactionResponse,
              printer,
            );
          } else {
            var device = BluetoothDevice(printer.name, printer.address);
            bluetooth.connect(device).then((value) {
              if (value) {
                PrintReceipt(bluetooth: bluetooth).print(
                  transactionResponse,
                  printer,
                );
              }
            });
          }
        });
      }
      _cartController.cartSessions.value = CartSession(
        cartItems: [],
      );
      _cartController.cartSessions.refresh();
      _productController.getProducts();
      _transactionController.fetchTransaction(
        PaginationRequest(
          page: 1,
          perPage: _transactionController.perPage,
        ),
      );
      Get.offAllNamed("/auth");
      Get.toNamed("/menu/transaction/cashier");
      Get.rawSnackbar(
        message: 'cashier_success_message'.tr,
        backgroundColor: success,
        duration: const Duration(seconds: 2),
      );
      isLoading(false);
    } catch (e) {
      isLoading(false);
      if (e is ValidationException) {
        ErrorResponse errorResponse =
            ErrorResponse.fromJson(jsonDecode(e.toString()), (json) => ());
        Get.rawSnackbar(
          message: errorResponse.message,
          backgroundColor: error,
        );
      }
    }
  }

  void printReceipt(BlueThermalPrinter bluetooth, Printer printer) {}
}
