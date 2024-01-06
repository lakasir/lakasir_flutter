import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/requests/payment_request.dart';
import 'package:lakasir/utils/auth.dart';

class PaymentSerivce {
  Future<void> store(PaymentRequest paymentRequest) async {
    await ApiService(await getDomain())
        .postData("transaction/selling", paymentRequest.toJson());
  }
}
