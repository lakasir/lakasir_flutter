import 'package:get/get.dart';
import 'package:lakasir/api/requests/payment_request.dart';
import 'package:lakasir/offline/models/pending_transaction_model.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/offline/services/offline_transaction_service.dart';
import 'package:lakasir/offline/services/online_transaction_service.dart';
import 'package:lakasir/offline/services/transaction_service_interface.dart';

class TransactionRepository implements TransactionServiceInterface {
  late final OfflineTransactionService _offlineService =
      OfflineTransactionService();
  late final OnlineTransactionService _onlineService =
      OnlineTransactionService();

  TransactionServiceInterface get _service =>
      Get.find<AppModeService>().isOnline ? _onlineService : _offlineService;

  @override
  Future<OfflinePendingTransaction> store(PaymentRequest request) {
    return _service.store(request);
  }

  @override
  Future<List<OfflinePendingTransaction>> getHistory() {
    return _service.getHistory();
  }

  @override
  Future<OfflinePendingTransaction?> getById(int id) {
    return _service.getById(id);
  }
}