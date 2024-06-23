import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/requests/pagination_request.dart';
import 'package:lakasir/api/requests/payment_request.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/controllers/settings/print_controller.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/controllers/transactions/history_controller.dart';
import 'package:lakasir/models/printer.dart';
import 'package:lakasir/screens/setting/printers/print_receipt.dart';
import 'package:lakasir/services/payment_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';

class PaymentController extends GetxController {
  final _paymentService = PaymentSerivce();
  final _cartController = Get.put(CartController());
  final _transactionController = Get.put(HistoryController());
  final RxBool isLoading = false.obs;

  void store() async {
    try {
      var change = _cartController.cartSessions.value.payedMoney! -
          _cartController.cartSessions.value.getTotalPrice;
      isLoading(true);
      procceedThePayment();
      Get.offAllNamed("/auth");
      Get.toNamed("/menu/transaction/cashier");
      Get.toNamed(
        "/menu/transaction/cashier/payment/success",
        arguments: change,
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

  void procceedThePayment() async {
    TransactionHistoryResponse transactionResponse =
        await _paymentService.store(PaymentRequest(
      discountPrice: _cartController.cartSessions.value.discountPrice,
      payedMoney: _cartController.cartSessions.value.payedMoney,
      friendPrice: false,
      tax: _cartController.cartSessions.value.tax,
      memberId: _cartController.cartSessions.value.member?.id,
      note: _cartController.cartSessions.value.note,
      products: _cartController.cartSessions.value.cartItems
          .map(
            (e) => PaymentRequestItem(
              productId: e.product.id,
              qty: e.qty,
              discountPrice: e.discountPrice,
            ),
          )
          .toList(),
    ));

    debug(transactionResponse.cashier!.name!);

    _transactionController.transaction(transactionResponse);
  }

  void printReceipt(BlueThermalPrinter bluetooth, Printer printer) {}
}
