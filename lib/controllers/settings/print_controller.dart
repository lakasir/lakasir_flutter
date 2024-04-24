import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/models/printer.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/select_input_feld.dart';

class ErrorRequest {
  String? name;
  String? address;

  ErrorRequest({
    this.name,
    this.address,
  });
}

class PrintController extends GetxController {
  RxList<Printer> printers = <Printer>[].obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController logoPath = TextEditingController();
  final SelectInputWidgetController deviceController =
      SelectInputWidgetController();
  final TextEditingController footerController = TextEditingController();
  RxBool isDefault = false.obs;
  RxBool connected = false.obs;
  RxBool isLoding = false.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rx<ErrorRequest> errorRequest = ErrorRequest().obs;

  void fetchPrinters() async {
    var results = await LakasirDatabase().printer.fetch();

    printers.assignAll(results);
  }

  Future<void> addPrinter() async {
    isLoding(true);
    if (!formKey.currentState!.validate()) {
      isLoding(false);
      return;
    }
    var nameIsExist = printers.any((element) =>
        element.name!.toLowerCase() == nameController.text.toLowerCase());
    if (nameIsExist) {
      show(
        "global_validation_field_exist".trParams({
          'field': 'field_name'.tr,
        }),
        color: error,
      );
      isLoding(false);
      return;
    }
    var addressIsExist = printers.any((element) =>
        element.address!.toLowerCase() ==
        deviceController.selectedOption!.toLowerCase());
    if (addressIsExist) {
      show(
        "global_validation_field_exist".trParams({
          'field': 'field_address'.tr,
        }),
        color: error,
      );
      isLoding(false);
      return;
    }
    if (!connected.value) {
      show(
        "global_validation_field_not_connected".tr,
        color: error,
      );
      isLoding(false);
      return;
    }
    var printer = Printer()
      ..name = nameController.text
      ..address = deviceController.selectedOption
      ..footer = footerController.text
      ..logopath = logoPath.text;
    await LakasirDatabase().printer.create(printer);

    clear();
    fetchPrinters();
    isLoding(false);
    Get.back();
    show(
      'global_added_item'.trParams({
        'item': 'setting_menu_printer'.tr,
      }),
      color: success,
    );
  }

  Future<void> deletePrinter(Printer printer) async {
    await LakasirDatabase().printer.delete(printer);

    Get.back();
    fetchPrinters();
    show(
      'global_deleted_item'.trParams({
        'item': 'setting_menu_printer'.tr,
      }),
      color: success,
    );
  }

  void clear() {
    nameController.clear();
    deviceController.selectedOption = "";
    footerController.clear();
    isDefault(false);
    connected(false);
    errorRequest(ErrorRequest());
  }
}
