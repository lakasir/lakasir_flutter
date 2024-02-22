import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/auths/profile_response.dart';
import 'package:lakasir/api/responses/members/member_response.dart';
import 'package:lakasir/api/responses/payment_methods/payment_method_response.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/api/responses/transactions/selling_detail.dart';
import 'package:lakasir/controllers/abouts/about_controller.dart';
import 'package:lakasir/controllers/settings/print_controller.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/checkbox.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class AddPrinterPageScreen extends StatefulWidget {
  const AddPrinterPageScreen({super.key});

  @override
  State<AddPrinterPageScreen> createState() => _AddPrinterPageScreenState();
}

class _AddPrinterPageScreenState extends State<AddPrinterPageScreen> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _bluetoothConnected = false;
  bool _isConnecting = false;
  final _printerController = Get.put(PrintController());

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _printerController.clear();
  }

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } catch (e) {
      if (e is PlatformException) {
        debugPrint(e.message);
      }
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _bluetoothConnected = true;
          });
          debugPrint("bluetooth device state: connected");
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _bluetoothConnected = false;
          });
          debugPrint("bluetooth device state: disconnected");
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _bluetoothConnected = false;
          });
          debugPrint("bluetooth device state: disconnect requested");
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _bluetoothConnected = false;
          });
          debugPrint("bluetooth device state: bluetooth turning off");
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _bluetoothConnected = false;
          });
          debugPrint("bluetooth device state: bluetooth off");
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _bluetoothConnected = false;
          });
          debugPrint("bluetooth device state: bluetooth on");
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _bluetoothConnected = false;
          });
          debugPrint("bluetooth device state: bluetooth turning on");
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _bluetoothConnected = false;
          });
          debugPrint("bluetooth device state: error");
          break;
        default:
          debugPrint(state.toString());
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        _bluetoothConnected = true;
      });
    }
  }

  void _printReceipt() {
    printExampleReceipt(bluetooth);
  }

  List<Option> _getDeviceItems() {
    List<Option> items = [];
    items.add(Option(
      value: 'no_device',
      name: 'global_no_item'.trParams({"item": "device".tr}),
    ));
    if (_devices.isNotEmpty) {
      for (var device in _devices) {
        items.add(Option(
          value: device.address!,
          name: device.name!,
          onTap: () {
            setState(() {
              _device = device;
            });
          },
        ));
      }
    }

    return items;
  }

  void _connect() {
    setState(() => _isConnecting = true);
    if (_device != null) {
      bluetooth.connect(_device!).then((value) async {
        _printerController.connected.value = true;
        show('success to connect with printer');
        setState(() {
          _bluetoothConnected = true;
          _isConnecting = false;
        });
      }).catchError((e) {
        show('No device selected.', color: error);
        setState(() {
          _bluetoothConnected = false;
          _isConnecting = false;
        });
        _printerController.connected.value = false;
      });
    } else {
      setState(() => _isConnecting = false);
      show('Device not found', color: error);
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _bluetoothConnected = false);
    show('success to disconnect with printer');
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Print'.tr,
      child: Obx(
        () => Form(
          key: _printerController.formKey,
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Obx(
                  () => MyTextField(
                    mandatory: true,
                    controller: _printerController.nameController,
                    label: 'field_name'.tr,
                    errorText: _printerController.errorRequest.value.name,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Obx(
                  () => SelectInputWidget(
                    mandatory: true,
                    label: 'field_device'.tr,
                    options: _getDeviceItems(),
                    controller: _printerController.deviceController,
                    errorText: _printerController.errorRequest.value.address,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: MyTextField(
                  maxLines: 4,
                  controller: _printerController.footerController,
                  label: 'field_footer'.tr,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: MyCheckbox(
                  label: 'field_default'.tr,
                  isChecked: _printerController.isDefault.value,
                  onChange: (bool? value) {
                    _printerController.isDefault.value = value!;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: MyFilledButton(
                  color: !_bluetoothConnected ? primary : error,
                  onPressed: !_bluetoothConnected ? _connect : _disconnect,
                  isLoading: _isConnecting,
                  child: !_bluetoothConnected
                      ? Text('field_connect'.tr)
                      : Text('field_disconnect'.tr),
                ),
              ),
              if (_bluetoothConnected)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: MyFilledButton(
                    color: secondary,
                    onPressed: _printReceipt,
                    child: Text('print_test'.tr),
                  ),
                ),
              Obx(
                () => MyFilledButton(
                  onPressed: () {
                    _printerController.addPrinter();
                  },
                  isLoading: _printerController.isLoding.value,
                  child: Text('global_save'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrintReceipt {
  final BlueThermalPrinter bluetooth;
  AboutController aboutController = Get.put(AboutController());

  PrintReceipt({required this.bluetooth});

  void print(TransactionHistoryResponse transactionHistoryResponse) async {
    if (aboutController.shop.value.photo!.isNotEmpty) {
      await bluetooth.printImage(aboutController.shop.value.photo!);
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
    await bluetooth.printLeftRight(
      "field_member".tr,
      transactionHistoryResponse.member!.name,
      0,
    );
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
      await bluetooth.printLeftRight(
        history.product!.name,
        "${formatPrice(history.product!.sellingPrice, isSymbol: false)} x ${history.quantity}",
        0,
      );
      await bluetooth.printCustom(
        formatPrice(history.price, isSymbol: false),
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
      'Subtotal'.tr,
      formatPrice(transactionHistoryResponse.totalPrice, isSymbol: false),
      1,
    );
    await bluetooth.printLeftRight(
      'field_tax'.tr,
      "${transactionHistoryResponse.tax!}%",
      1,
    );
    await bluetooth.printLeftRight(
      'field_total_price'.tr,
      formatPrice(
        ((transactionHistoryResponse.totalPrice ?? 0) *
                (transactionHistoryResponse.tax ?? 0) /
                100) +
            transactionHistoryResponse.totalPrice!,
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
    await bluetooth.paperCut();
  }
}
