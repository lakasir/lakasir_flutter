import 'package:lakasir/api/requests/payment_request.dart';
import 'package:lakasir/offline/models/pending_transaction_model.dart';

abstract class TransactionServiceInterface {
  Future<OfflinePendingTransaction> store(PaymentRequest request);
  Future<List<OfflinePendingTransaction>> getHistory();
  Future<OfflinePendingTransaction?> getById(int id);
}