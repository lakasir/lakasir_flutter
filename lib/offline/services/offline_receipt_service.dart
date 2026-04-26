import 'package:isar/isar.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/pending_transaction_model.dart';

class OfflineReceiptService {
  static Future<String> generateReceiptNumber() async {
    final isar = LakasirDatabase.isar;
    final today = DateTime.now();
    final dateStr =
        '${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}';
    final startOfDay = DateTime(today.year, today.month, today.day);
    final todayCount = await isar.offlinePendingTransactions
        .where()
        .filter()
        .createdAtGreaterThan(startOfDay)
        .count();
    final seq = (todayCount + 1).toString().padLeft(4, '0');
    return 'OFF-$dateStr-$seq';
  }
}