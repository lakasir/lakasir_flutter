import 'package:get/get.dart';
import 'package:lakasir/utils/auth.dart';

enum AppMode { offline, online }

class AppModeService extends GetxController {
  final Rx<AppMode> mode = AppMode.offline.obs;

  bool get isOffline => mode.value == AppMode.offline;
  bool get isOnline => mode.value == AppMode.online;

  Future<void> determineMode() async {
    final hasDomainFlag = await hasDomain();
    if (hasDomainFlag) {
      mode.value = AppMode.online;
    } else {
      mode.value = AppMode.offline;
    }
  }

  Future<void> switchToOnline([String? domain]) async {
    if (domain != null) {
      await storeSetup(domain);
    }
    mode.value = AppMode.online;
    // TODO: trigger full sync via SyncService (Phase 4)
  }

  void switchToOffline() {
    mode.value = AppMode.offline;
  }
}