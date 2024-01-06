import 'package:get/get.dart';
import 'package:lakasir/api/responses/payment_methods/payment_method_response.dart';
import 'package:lakasir/services/payment_method_service.dart';

class PaymentMethodController extends GetxController {
  RxList paymentMethods = <PaymentMethodRespone>[].obs;
  final _paymentMethodService = PaymentMethodService();
  RxBool isFetching = false.obs;

  Future<void> fetchPaymentMethods() async {
    isFetching(true);
    final response = await _paymentMethodService.get();
    paymentMethods.assignAll(response);
    isFetching(false);
  }

  @override
  void onInit() {
    fetchPaymentMethods();
    super.onInit();
  }
}
