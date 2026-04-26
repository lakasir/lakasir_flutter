import 'dart:convert';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:lakasir/api/requests/payment_request.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/pending_transaction_model.dart';
import 'package:lakasir/offline/services/connectivity_service.dart';
import 'package:lakasir/services/payment_service.dart' as api;

class TransactionQueueService extends GetxController {
  final RxInt pendingCount = 0.obs;
  final RxInt failedCount = 0.obs;
  final RxBool isSyncing = false.obs;
  final _isar = LakasirDatabase.isar;
  final _apiService = api.PaymentSerivce();

  static const int _maxRetries = 3;

  @override
  void onInit() {
    super.onInit();
    _refreshCounts();
  }

  void _refreshCounts() {
    _isar.offlinePendingTransactions
        .where()
        .filter()
        .isSyncedEqualTo(false)
        .findAll()
        .then((unsynced) {
      pendingCount.value =
          unsynced.where((t) => t.retryCount < _maxRetries).length;
      failedCount.value =
          unsynced.where((t) => t.retryCount >= _maxRetries).length;
    });
  }

  Future<void> attemptSync() async {
    if (isSyncing.value) return;

    final connectivity = Get.find<ConnectivityService>();
    if (!connectivity.isOnline.value) return;

    isSyncing.value = true;
    try {
      final unsynced = await _isar.offlinePendingTransactions
          .where()
          .filter()
          .isSyncedEqualTo(false)
          .and()
          .retryCountLessThan(_maxRetries)
          .findAll();

      for (final transaction in unsynced) {
        try {
          final items = (jsonDecode(transaction.itemsJson) as List)
              .map((e) => PaymentRequestItem.fromJson(e))
              .toList();

          final request = PaymentRequest(
            payedMoney: transaction.payedMoney,
            discountPrice: transaction.discountPrice,
            friendPrice: transaction.friendPrice,
            memberId: transaction.memberId,
            tax: transaction.tax,
            note: transaction.note,
            products: items,
          );

          final response = await _apiService.store(request);

          await _isar.writeTxn(() async {
            transaction.isSynced = true;
            transaction.serverTransactionId = response.id.toString();
            await _isar.offlinePendingTransactions.put(transaction);
          });
        } catch (e) {
          await _isar.writeTxn(() async {
            transaction.retryCount++;
            transaction.errorMessage = e.toString();
            await _isar.offlinePendingTransactions.put(transaction);
          });
        }
      }
    } finally {
      isSyncing.value = false;
      _refreshCounts();
    }
  }

  Future<List<OfflinePendingTransaction>> getFailedTransactions() async {
    return await _isar.offlinePendingTransactions
        .where()
        .filter()
        .isSyncedEqualTo(false)
        .and()
        .retryCountGreaterThan(_maxRetries - 1)
        .findAll();
  }

  Future<void> retryFailedTransaction(int id) async {
    final transaction =
        await _isar.offlinePendingTransactions.get(id);
    if (transaction == null) return;

    await _isar.writeTxn(() async {
      transaction.retryCount = 0;
      transaction.errorMessage = null;
      await _isar.offlinePendingTransactions.put(transaction);
    });

    _refreshCounts();
    await attemptSync();
  }

  Future<void> clearSyncedTransactions() async {
    await _isar.writeTxn(() async {
      await _isar.offlinePendingTransactions
          .where()
          .filter()
          .isSyncedEqualTo(true)
          .deleteAll();
    });
    _refreshCounts();
  }

  Future<void> deleteTransaction(int id) async {
    await _isar.writeTxn(() async {
      await _isar.offlinePendingTransactions.delete(id);
    });
    _refreshCounts();
  }
}