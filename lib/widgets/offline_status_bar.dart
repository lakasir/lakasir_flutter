import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/offline/services/connectivity_service.dart';
import 'package:lakasir/offline/services/transaction_queue_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';

class ModeStatusBar extends StatelessWidget {
  const ModeStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appMode = Get.find<AppModeService>();
    final connectivity = Get.find<ConnectivityService>();

    return Obx(() {
      final isOnline = appMode.isOnline;
      final isConnected = connectivity.isOnline.value;
      final intendsOnline = appMode.intendsOnline.value;

      if (intendsOnline) {
        return const SizedBox.shrink();
      }

      if (isOnline && isConnected) {
        return const SizedBox.shrink();
      }

      if (!isOnline && !appMode.hasDomainFlag.value) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.blueGrey,
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                const Icon(Icons.cloud_off, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'offline_mode_indicator'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (!isConnected) {
        String message = 'no_connection_cached'.tr;
        int? pendingCount;
        if (Get.isRegistered<TransactionQueueService>()) {
          pendingCount = Get.find<TransactionQueueService>().pendingCount.value;
        }
        if (pendingCount != null && pendingCount > 0) {
          message = 'no_connection_pending'.tr.replaceAll('{count}', pendingCount.toString());
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: error,
          child: SafeArea(
            bottom: false,
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }
}
