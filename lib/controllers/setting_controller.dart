import 'package:get/get.dart';
import 'package:lakasir/api/responses/setting_response.dart';
import 'package:lakasir/controllers/transactions/cash_drawer_controller.dart';
import 'package:lakasir/services/setting_service.dart';

class SettingController extends GetxController {
  Rx<SettingResponse> settingResponse = SettingResponse().obs;
  final SettingService _settingService = SettingService();
  final _cashDrawerController = Get.put(CashDrawerController());
  Rx<Setting> setting = Setting().obs;

  void getSetting(String key) async {
    final response = await _settingService.get(key);
    settingResponse(response);
  }

  void getAllSetting() async {
    final response = await _settingService.getAll();
    setting(response);
  }

  void updateSetting(String key, dynamic value) async {
    await _settingService.set(SettingRequest(key: key, value: value));
    getAllSetting();
    getSetting(key);
  }

  @override
  void onInit() {
    getAllSetting();
    super.onInit();
  }

  @override
  void onReady() {
    if (setting.value.cashDrawerEnabled) {
      _cashDrawerController.showCashDrawerDialog();
    }
    super.onReady();
  }
}
