import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/requests/pagination_request.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/pagination_response.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/utils/auth.dart';

class HistoryService {
  Future<PaginationResponse<TransactionHistoryResponse>> get(
      PaginationRequest request) async {
    String tzName = DateTime.now().timeZoneName;
    final response = await ApiService(await getDomain()).fetchData(
      'transaction/selling${request.toQuery()}&timezone=$tzName',
    );

    final apiResponse = ApiResponse.fromJson(response, (contentJson) {
      return PaginationResponse<TransactionHistoryResponse>.fromJson(
        contentJson,
        (dataJson) {
          return TransactionHistoryResponse.fromJson(dataJson);
        },
      );
    });

    return apiResponse.data?.value ?? PaginationResponse();
  }
}
