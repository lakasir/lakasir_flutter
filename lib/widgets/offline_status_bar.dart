import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/offline/services/connectivity_service.dart';
import 'package:lakasir/utils/colors.dart';

class ModeStatusBar extends StatelessWidget {
  const ModeStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appMode = Get.find<AppModeService>();
    final connectivity = Get.find<ConnectivityService>();

    return Obx(() {
      final isOnline = appMode.isOnline;
      final isConnected = connectivity.isOnline.value;

      // Online and connected — no banner needed
      if (isOnline && isConnected) {
        return const SizedBox.shrink();
      }

      // Offline-only mode (no domain configured)
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

      // Online mode but network dropped (or offline with domain — cached data)
      if (!isConnected) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: error,
          child: SafeArea(
            bottom: false,
            child: Text(
              'no_connection_cached'.tr,
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