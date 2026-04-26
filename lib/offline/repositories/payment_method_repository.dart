import 'package:get/get.dart';
import 'package:lakasir/offline/models/offline_payment_method_model.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/offline/services/offline_payment_method_service.dart';
import 'package:lakasir/offline/services/online_payment_method_service.dart';
import 'package:lakasir/offline/services/payment_method_service_interface.dart';

class PaymentMethodRepository implements PaymentMethodServiceInterface {
  late final OfflinePaymentMethodService _offlineService = OfflinePaymentMethodService();
  late final OnlinePaymentMethodService _onlineService = OnlinePaymentMethodService();

  PaymentMethodServiceInterface get _service =>
      Get.find<AppModeService>().isOnline ? _onlineService : _offlineService;

  @override
  Future<List<OfflinePaymentMethod>> getPaymentMethods() {
    return _service.getPaymentMethods();
  }

  @override
  Future<OfflinePaymentMethod?> getPaymentMethodById(int id) {
    return _service.getPaymentMethodById(id);
  }

  @override
  Future<OfflinePaymentMethod> createPaymentMethod(OfflinePaymentMethod paymentMethod) {
    return _service.createPaymentMethod(paymentMethod);
  }

  @override
  Future<OfflinePaymentMethod> updatePaymentMethod(OfflinePaymentMethod paymentMethod) {
    return _service.updatePaymentMethod(paymentMethod);
  }

  @override
  Future<void> deletePaymentMethod(int id) {
    return _service.deletePaymentMethod(id);
  }
}