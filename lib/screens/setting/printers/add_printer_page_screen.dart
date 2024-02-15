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
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
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
  bool _connected = false;
  bool _isConnecting = false;
  SelectInputWidgetController controller = SelectInputWidgetController();
  TextEditingController nameController = TextEditingController();
  TextEditingController footerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    if (_connected) {
      controller.selectedOption = _device!.address;
    } else {
      controller.selectedOption = 'no_device';
    }
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
            _connected = true;
          });
          debugPrint("bluetooth device state: connected");
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          debugPrint("bluetooth device state: disconnected");
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
          });
          debugPrint("bluetooth device state: disconnect requested");
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
          });
          debugPrint("bluetooth device state: bluetooth turning off");
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
          });
          debugPrint("bluetooth device state: bluetooth off");
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
          });
          debugPrint("bluetooth device state: bluetooth on");
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
          });
          debugPrint("bluetooth device state: bluetooth turning on");
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
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
        _connected = true;
      });
    }
  }

  void _printReceipt() {
    PrintReceipt(bluetooth: bluetooth).print(
      TransactionHistoryResponse(
        id: 1,
        userId: 1,
        cashier: ProfileResponse(
          name: 'Cashier name',
          email: 'cashier@mail.com',
        ),
        friendPrice: false,
        paymentMethodId: 1,
        totalPrice: 375000,
        tax: 25,
        member: MemberResponse(id: 1, name: 'member_name'.tr),
        paymentMethod: PaymentMethodRespone(id: 1, name: "Cash"),
        payedMoney: 400000,
        moneyChange: 25000,
        sellingDetails: [
          SellingDetail(
            quantity: 3,
            price: 75000,
            productId: 1,
            sellingId: 1,
            id: 0,
            product: ProductResponse(
              name: 'product_name'.tr,
              sellingPrice: 25000,
            ),
          ),
          SellingDetail(
            quantity: 3,
            price: 75000,
            productId: 1,
            sellingId: 1,
            id: 0,
            product: ProductResponse(
              name: 'product_name'.tr,
              sellingPrice: 25000,
            ),
          ),
          SellingDetail(
            quantity: 3,
            price: 75000,
            productId: 1,
            sellingId: 1,
            id: 0,
            product: ProductResponse(
              name: 'product_name'.tr,
              sellingPrice: 25000,
            ),
          ),
          SellingDetail(
            quantity: 3,
            price: 75000,
            productId: 1,
            sellingId: 1,
            id: 0,
            product: ProductResponse(
              name: 'product_name'.tr,
              sellingPrice: 25000,
            ),
          ),
          SellingDetail(
            quantity: 3,
            price: 75000,
            productId: 1,
            sellingId: 1,
            id: 0,
            product: ProductResponse(
              name: 'product_name'.tr,
              sellingPrice: 25000,
            ),
          ),
        ],
      ),
    );
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
        show('success to connect with printer');
        setState(() {
          _connected = true;
          _isConnecting = false;
        });
      }).catchError((e) {
        show('No device selected.', color: error);
        setState(() {
          _connected = false;
          _isConnecting = false;
        });
      });
    } else {
      setState(() => _isConnecting = false);
      show('Device not found', color: error);
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
    show('success to disconnect with printer');
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Print'.tr,
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: MyTextField(
              controller: nameController,
              label: 'field_name'.tr,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: SelectInputWidget(
              label: 'field_device'.tr,
              options: _getDeviceItems(),
              controller: controller,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: MyTextField(
              maxLines: 4,
              controller: footerController,
              label: 'field_footer'.tr,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: MyFilledButton(
              color: !_connected ? primary : error,
              onPressed: !_connected ? _connect : _disconnect,
              isLoading: _isConnecting,
              child: !_connected
                  ? Text('field_connect'.tr)
                  : Text('field_disconnect'.tr),
            ),
          ),
          if (_connected)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: MyFilledButton(
                color: secondary,
                onPressed: _printReceipt,
                child: Text('print_test'.tr),
              ),
            ),
          MyFilledButton(
            onPressed: () {
              LakasirDatabase().createPrinters(
                name: nameController.text,
                address: _device?.address,
                footer: footerController.text,
              );
              Get.back();
              show(
                'global_added_item'.trParams({
                  'item': 'setting_menu_printer'.tr,
                }),
                color: success,
              );
            },
            child: Text('global_save'.tr),
          ),
        ],
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
