import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:lakasir/api/requests/payment_request.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/pending_transaction_model.dart';
import 'package:lakasir/offline/services/offline_receipt_service.dart';
import 'package:lakasir/offline/services/transaction_service_interface.dart';

class OfflineTransactionService implements TransactionServiceInterface {
  final _isar = LakasirDatabase.isar;

  @override
  Future<OfflinePendingTransaction> store(PaymentRequest request) async {
    final receiptNumber =
        await OfflineReceiptService.generateReceiptNumber();

    final transaction = OfflinePendingTransaction()
      ..payedMoney = request.payedMoney
      ..discountPrice = request.discountPrice
      ..friendPrice = request.friendPrice
      ..memberId = request.memberId
      ..tax = request.tax
      ..note = request.note
      ..itemsJson =
          jsonEncode(request.products?.map((item) => item.toJson()).toList() ?? [])
      ..isSynced = false
      ..offlineReceiptNumber = receiptNumber;

    await _isar.writeTxn(() async {
      await _isar.offlinePendingTransactions.put(transaction);
    });

    return transaction;
  }

  @override
  Future<List<OfflinePendingTransaction>> getHistory() async {
    return await _isar.offlinePendingTransactions.where().findAll();
  }

  @override
  Future<OfflinePendingTransaction?> getById(int id) async {
    return await _isar.offlinePendingTransactions.get(id);
  }
}