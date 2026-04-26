import 'package:lakasir/offline/models/offline_payment_method_model.dart';

abstract class PaymentMethodServiceInterface {
  Future<List<OfflinePaymentMethod>> getPaymentMethods();
  Future<OfflinePaymentMethod?> getPaymentMethodById(int id);
  Future<OfflinePaymentMethod> createPaymentMethod(OfflinePaymentMethod paymentMethod);
  Future<OfflinePaymentMethod> updatePaymentMethod(OfflinePaymentMethod paymentMethod);
  Future<void> deletePaymentMethod(int id);
}