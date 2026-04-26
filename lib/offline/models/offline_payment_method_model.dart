import 'package:isar/isar.dart';

part 'offline_payment_method_model.g.dart';

@collection
class OfflinePaymentMethod {
  Id id = Isar.autoIncrement;

  int? remoteId;
  String name = '';
  String? icon;
  bool isCash = false;
  bool isDebit = false;
  bool isCredit = false;
  bool isWallet = false;
  DateTime? cachedAt;
  bool isLocal = false;

  OfflinePaymentMethod();
}