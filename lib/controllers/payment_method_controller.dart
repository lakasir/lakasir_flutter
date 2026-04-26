import 'package:get/get.dart';
import 'package:lakasir/offline/models/offline_payment_method_model.dart';
import 'package:lakasir/offline/repositories/payment_method_repository.dart';

class PaymentMethodController extends GetxController {
  RxList<OfflinePaymentMethod> paymentMethods = <OfflinePaymentMethod>[].obs;
  final PaymentMethodRepository _paymentMethodRepository = PaymentMethodRepository();
  RxBool isFetching = false.obs;

  Future<void> fetchPaymentMethods() async {
    isFetching(true);
    paymentMethods.assignAll(await _paymentMethodRepository.getPaymentMethods());
    isFetching(false);
  }

  @override
  void onInit() {
    fetchPaymentMethods();
    super.onInit();
  }
}