import 'package:get/get.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/services/history_service.dart';

class HistoryController extends GetxController {
  RxBool isLoading = false.obs;
  final _historyService = HistoryService();
  RxList<TransactionHistoryResponse> histories =
      <TransactionHistoryResponse>[].obs;

  void getTransactionHistory() async {
    isLoading.value = true;
    final response = await _historyService.get();
    histories.value = response.data!;
    isLoading.value = false;
  }

  @override
  void onInit() {
    getTransactionHistory();
    super.onInit();
  }
}
