import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/services/transaction_queue_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'syncPendingTransactions':
        try {
          await LakasirDatabase.initialize();

          final queueService = TransactionQueueService();
          queueService.onInit();
          await queueService.attemptSync();

          return true;
        } catch (e) {
          debugPrint('Background sync failed: $e');
          return false;
        }
      default:
        return false;
    }
  });
}

class BackgroundSyncService {
  static const String _taskName = 'syncPendingTransactions';

  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  static Future<void> schedulePeriodicSync() async {
    await Workmanager().registerPeriodicTask(
      _taskName,
      _taskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }

  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }
}