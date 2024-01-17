import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/requests/cash_drawer_request.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/cash_drawers/cash_drawer_response.dart';
import 'package:lakasir/utils/auth.dart';

class CashDrawerService {
  Future<CashDrawerResponse> get() async {
    final response = await ApiService(await getDomain()).fetchData('transaction/cash-drawer');
    ApiResponse<CashDrawerResponse> profileResponse = ApiResponse.fromJson(
      response,
      (json) {
        if (json['id'] == null) {
          return CashDrawerResponse();
        }
        return CashDrawerResponse.fromJson(json);
      },
    );

    if (!profileResponse.success) {
      throw Exception('Failed to load data');
    }
    
    return profileResponse.data!.value;
  }

  Future<void> store(CashDrawerRequest cashDrawerRequest) async {
    await ApiService(await getDomain()).postData(
      'transaction/cash-drawer',
      cashDrawerRequest.toJson(),
    );
  }

  Future<void> close() async {
    await ApiService(await getDomain()).postData(
      'transaction/cash-drawer/close', {}
    );
  }

}
