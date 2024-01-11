import 'package:get/get.dart';
import 'package:lakasir/api/requests/pagination_request.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/services/history_service.dart';

class HistoryController extends GetxController {
  RxBool isLoading = false.obs;
  final _historyService = HistoryService();
  RxList<TransactionHistoryResponse> histories =
      <TransactionHistoryResponse>[].obs;
  int perPage = 20;

  Future<void> fetchTransaction(PaginationRequest request) async {
    isLoading.value = true;
    final response = await _historyService.get(request);
    histories.value = response.data!;
    isLoading.value = false;
  }

  // @override
  // void onInit() {
  //   fetchTransaction(PaginationRequest(page: 1, perPage: perPage));
  //   super.onInit();
  // }
}
