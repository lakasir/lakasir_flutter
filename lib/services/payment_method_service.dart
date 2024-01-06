import 'package:get/get.dart';
import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/payment_methods/payment_method_response.dart';
import 'package:lakasir/utils/auth.dart';

class PaymentMethodService {
  Future<RxList<PaymentMethodRespone>> get() async {
    final response = await await ApiService(await getDomain())
        .fetchData("master/payment-method");

    final apiResponse = ApiResponse.fromJsonList(response, (json) {
      return RxList<PaymentMethodRespone>.from(
          json.map((x) => PaymentMethodRespone.fromJson(x)));
    });

    return apiResponse.data!.value;
  }
}
