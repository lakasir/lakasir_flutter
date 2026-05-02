import 'package:get/get.dart';
import 'package:lakasir/utils/auth.dart';

enum AppMode { offline, online }

class AppModeService extends GetxController {
  final Rx<AppMode> mode = AppMode.offline.obs;
  final RxBool hasDomainFlag = false.obs;
  final RxBool intendsOnline = false.obs;

  bool get isOffline => mode.value == AppMode.offline;
  bool get isOnline => mode.value == AppMode.online;

  Future<void> determineMode() async {
    final hasDomainResult = await hasDomain();
    hasDomainFlag.value = hasDomainResult;
    if (hasDomainResult) {
      mode.value = AppMode.online;
    } else {
      mode.value = AppMode.offline;
    }
  }

  Future<void> switchToOnline([String? domain]) async {
    if (domain != null) {
      await storeSetup(domain);
    }
    hasDomainFlag.value = true;
    intendsOnline.value = false;
    mode.value = AppMode.online;
    // TODO: trigger full sync via SyncService (Phase 4)
  }

  void switchToOffline() {
    intendsOnline.value = false;
    mode.value = AppMode.offline;
  }
}