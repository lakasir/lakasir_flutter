import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/requests/payment_request.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/utils/auth.dart';

class PaymentSerivce {
  Future<TransactionHistoryResponse> store(
      PaymentRequest paymentRequest) async {
    final response = await ApiService(await getDomain())
        .postData("transaction/selling", paymentRequest.toJson());

    final apiResponse = ApiResponse.fromJson(response, (json) {
      return TransactionHistoryResponse.fromJson(json);
    });

    return apiResponse.data!.value;
  }
}
