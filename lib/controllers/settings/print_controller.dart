import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get/get.dart';
import 'package:lakasir/widgets/select_input_feld.dart';

class PrintController extends GetxController {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  RxList<BluetoothDevice> _devices = [].obs;
  BluetoothDevice? _device;
  RxBool _connected = false.obs;
  RxBool _isConnecting = false.obs;
  SelectInputWidgetController controller = SelectInputWidgetController();
}
