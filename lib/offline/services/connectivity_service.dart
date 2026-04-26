import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/offline/services/transaction_queue_service.dart';
import 'package:lakasir/utils/auth.dart';

class ConnectivityService extends GetxController {
  final RxBool isOnline = false.obs;
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    checkConnection().then((connected) {
      isOnline.value = connected;
    });
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final wasOnline = isOnline.value;
    isOnline.value = !results.contains(ConnectivityResult.none);

    final appMode = Get.find<AppModeService>();

    if (!isOnline.value && wasOnline) {
      if (appMode.isOnline) {
        appMode.switchToOffline();
      }
    } else if (isOnline.value && !wasOnline) {
      if (appMode.isOffline && await hasDomain()) {
        await appMode.switchToOnline();
      }
      // Trigger sync of pending transactions when coming back online
      if (Get.isRegistered<TransactionQueueService>()) {
        Get.find<TransactionQueueService>().attemptSync();
      }
    }
  }

  Future<bool> checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}