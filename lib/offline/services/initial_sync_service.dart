import 'package:get/get.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/offline/services/sync_service.dart';
import 'package:lakasir/offline/services/transaction_queue_service.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialSyncService {
  final SyncService _syncService = SyncService();

  Future<bool> performInitialSync(String domain) async {
    try {
      // Step 1: Validate domain by storing it
      await storeSetup(domain);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('setup', true);

      // Step 2: Switch to online mode (sets domain for API calls)
      final appMode = Get.find<AppModeService>();
      await appMode.switchToOnline(domain);

      // Step 3: Run full sync (downloads all server data)
      if (!Get.isRegistered<SyncService>()) {
        Get.put(_syncService, permanent: true);
      }
      await _syncService.fullSync();

      // Step 4: Sync any pending transactions
      if (Get.isRegistered<TransactionQueueService>()) {
        await Get.find<TransactionQueueService>().attemptSync();
      }

      return true;
    } catch (e) {
      // If sync fails, revert to offline mode
      final appMode = Get.find<AppModeService>();
      appMode.switchToOffline();
      return false;
    }
  }
}