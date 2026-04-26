import 'package:isar/isar.dart';

part 'pending_transaction_model.g.dart';

@collection
class OfflinePendingTransaction {
  Id id = Isar.autoIncrement;

  double? payedMoney;
  double discountPrice = 0;
  bool? friendPrice;
  int? memberId;
  double? tax;
  String? note;
  String itemsJson = '[]';
  bool isSynced = false;
  int retryCount = 0;
  DateTime createdAt = DateTime.now();
  String? serverTransactionId;
  String? errorMessage;
  String? offlineReceiptNumber;

  OfflinePendingTransaction();
}