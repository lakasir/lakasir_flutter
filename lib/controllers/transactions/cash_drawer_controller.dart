import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/requests/cash_drawer_request.dart';
import 'package:lakasir/api/responses/cash_drawers/cash_drawer_response.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/services/cash_drawer_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/text_field.dart';

class CashDrawerController extends GetxController {
  final _cashDrawerService = CashDrawerService();
  Rx<CashDrawerResponse> cashDrawerResponse = CashDrawerResponse().obs;
  RxBool isOpened = false.obs;
  RxBool isCanBeClosed = false.obs;
  final MoneyMaskedTextController cashDrawerController =
      MoneyMaskedTextController(thousandSeparator: '.', decimalSeparator: ',');

  Future<void> getCashDrawer() async {
    try {
      final response = await _cashDrawerService.get();
      cashDrawerResponse(response);
      isOpened(false);
      isCanBeClosed(true);
    } catch (e) {
      isOpened(true);
      isCanBeClosed(false);
      cashDrawerResponse(CashDrawerResponse());
    }
  }

  Future<void> storeCashDrawer(double cashDrawer) async {
    await _cashDrawerService.store(CashDrawerRequest(cash: cashDrawer));
    await getCashDrawer();
  }

  Future<void> closeCashDrawer() async {
    await _cashDrawerService.close();
    await getCashDrawer();
  }

  void showCashDrawerDialog() {
    if (cashDrawerResponse.value.cash != null) {
      cashDrawerController.updateValue(cashDrawerResponse.value.cash!);
    } else {
      cashDrawerController.updateValue(0);
    }
    Get.dialog(
      MyDialog(
        title: 'cashier_set_cash_drawer'.tr,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'cashier_set_cash_drawer_info'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: error,
              ),
            ),
            Text(
              'cashier_cash_drawer_current'.trParams(
                {'cash': formatPrice(cashDrawerResponse.value.cash ?? 0)},
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: secondary,
              ),
            ),
            const Divider(),
            MyTextField(
              label: 'cashier_cash_drawer'.tr,
              keyboardType: TextInputType.number,
              controller: cashDrawerController,
            ),
            Row(
              children: [
                if (isCanBeClosed.value)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: MyFilledButton(
                        color: error,
                        onPressed: () {
                          closeCashDrawer();
                          Get.back();
                          Get.rawSnackbar(
                            message: 'cashier_cash_drawer_closed'.tr,
                            backgroundColor: success,
                            duration: const Duration(seconds: 2),
                          );
                        },
                        child: Text(
                          'cashier_cash_drawer_close'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (isCanBeClosed.value) const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: MyFilledButton(
                      onPressed: () {
                        storeCashDrawer(cashDrawerController.numberValue);
                        Get.back();
                        Get.rawSnackbar(
                          message: 'global_added_item'.trParams(
                            {'item': 'cashier_cash_drawer'.tr},
                          ),
                          backgroundColor: success,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: const Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  onInit() {
    getCashDrawer();
    super.onInit();
  }
}
