import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/requests/payment_request.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/models/printer.dart';
import 'package:lakasir/offline/models/pending_transaction_model.dart';
import 'package:lakasir/offline/repositories/transaction_repository.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';

class PaymentController extends GetxController {
  final _transactionRepository = TransactionRepository();
  final _cartController = Get.put(CartController());
  final RxBool isLoading = false.obs;
  final Rx<OfflinePendingTransaction?> lastTransaction = Rx<OfflinePendingTransaction?>(null);

  void store() async {
    try {
      var change = _cartController.cartSessions.value.payedMoney! -
          _cartController.cartSessions.value.getTotalPrice;
      isLoading(true);
      await procceedThePayment();
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
        show(errorResponse.message, color: error);
      }
    }
  }

  Future<void> procceedThePayment() async {
    final transaction = await _transactionRepository.store(PaymentRequest(
      discountPrice: _cartController.cartSessions.value.discountPrice,
      payedMoney: _cartController.cartSessions.value.payedMoney,
      friendPrice: false,
      tax: _cartController.cartSessions.value.tax,
      memberId: _cartController.cartSessions.value.member?.remoteId ??
          _cartController.cartSessions.value.member?.id,
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

    lastTransaction.value = transaction;
  }

  void printReceipt(BlueThermalPrinter bluetooth, Printer printer) {}
}