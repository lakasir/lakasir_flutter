import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/controllers/abouts/about_controller.dart';
import 'package:lakasir/models/printer.dart';
import 'package:lakasir/utils/utils.dart';

class PrintReceipt {
  final BlueThermalPrinter bluetooth;
  AboutController aboutController = Get.put(AboutController());

  PrintReceipt({required this.bluetooth});

  void print(
    TransactionHistoryResponse transactionHistoryResponse,
    Printer printer, {
    copy = false,
  }) async {
    if (printer.logopath!.isNotEmpty) {
      await bluetooth.printImage(printer.logopath!);
    }
    await bluetooth.printCustom(aboutController.shop.value.shopeName!, 3, 1);
    await bluetooth.printCustom(
      "",
      1,
      1,
    );
    await bluetooth.printCustom(
      aboutController.shop.value.location ?? 'Location',
      1,
      1,
    );
    await bluetooth.printCustom(
      "-------------------------------",
      1,
      1,
    );
    await bluetooth.printLeftRight(
      "field_cashier".tr,
      transactionHistoryResponse.cashier!.name ??
          transactionHistoryResponse.cashier!.email!,
      0,
    );
    if (transactionHistoryResponse.member != null) {
      await bluetooth.printLeftRight(
        "field_member".tr,
        transactionHistoryResponse.member!.name,
        0,
      );
    }
    await bluetooth.printLeftRight(
      "field_payment_method".tr,
      transactionHistoryResponse.paymentMethod!.name,
      0,
    );
    await bluetooth.printCustom(
      "-------------------------------",
      1,
      1,
    );
    for (var history in transactionHistoryResponse.sellingDetails!) {
      var buildRowPrice =
          "${formatPrice(history.product!.sellingPrice, isSymbol: false)} x ${history.quantity}";

      if (history.discount != 0) {
        buildRowPrice =
            "${formatPrice(history.discount, isSymbol: false)} - $buildRowPrice";
      }

      await bluetooth.printLeftRight(
        history.product!.name,
        buildRowPrice,
        0,
      );
      await bluetooth.printCustom(
        formatPrice(history.discountPrice, isSymbol: false),
        0,
        2,
      );
    }
    await bluetooth.printCustom(
      "-------------------------------",
      1,
      1,
    );
    await bluetooth.printLeftRight(
      'field_tax'.tr,
      "${transactionHistoryResponse.tax!}%",
      0,
    );
    await bluetooth.printLeftRight(
      'field_tax_price'.tr,
      formatPrice(transactionHistoryResponse.taxPrice!, isSymbol: false),
      0,
    );
    await bluetooth.printLeftRight(
      'field_discount'.tr,
      "(${formatPrice(transactionHistoryResponse.totalDiscountPerItem)})",
      0,
    );
    await bluetooth.printLeftRight(
      'Subtotal'.tr,
      formatPrice(transactionHistoryResponse.totalPrice, isSymbol: false),
      0,
    );
    await bluetooth.printLeftRight(
      'field_total_price'.tr,
      formatPrice(
        transactionHistoryResponse.grandTotalPrice,
        isSymbol: false,
      ),
      1,
    );
    await bluetooth.printCustom(
      "-------------------------------",
      1,
      1,
    );
    await bluetooth.printLeftRight(
      'field_payed_money'.tr,
      formatPrice(transactionHistoryResponse.payedMoney!),
      1,
    );
    await bluetooth.printLeftRight(
      'field_change'.tr,
      formatPrice(transactionHistoryResponse.moneyChange!),
      1,
    );
    await bluetooth.printCustom(
      "-------------------------------",
      1,
      1,
    );
    await bluetooth.printCustom(
      printer.footer ?? "",
      1,
      1,
    );
    if (copy!) {
      await bluetooth.printCustom(
        "Copy",
        1,
        0,
      );
    }
    await bluetooth.paperCut();
  }
}
