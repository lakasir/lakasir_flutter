import 'package:isar/isar.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_payment_method_model.dart';
import 'package:lakasir/offline/services/payment_method_service_interface.dart';

class OfflinePaymentMethodService implements PaymentMethodServiceInterface {
  final _isar = LakasirDatabase.isar;

  @override
  Future<List<OfflinePaymentMethod>> getPaymentMethods() async {
    return await _isar.offlinePaymentMethods.where().findAll();
  }

  @override
  Future<OfflinePaymentMethod?> getPaymentMethodById(int id) async {
    return await _isar.offlinePaymentMethods.get(id);
  }

  @override
  Future<OfflinePaymentMethod> createPaymentMethod(OfflinePaymentMethod paymentMethod) async {
    final count = await _isar.offlinePaymentMethods.count();
    paymentMethod
      ..id = -(count + 1)
      ..isLocal = true
      ..cachedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.offlinePaymentMethods.put(paymentMethod);
    });

    return paymentMethod;
  }

  @override
  Future<OfflinePaymentMethod> updatePaymentMethod(OfflinePaymentMethod paymentMethod) async {
    paymentMethod
      ..isLocal = true
      ..cachedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.offlinePaymentMethods.put(paymentMethod);
    });

    return paymentMethod;
  }

  @override
  Future<void> deletePaymentMethod(int id) async {
    await _isar.writeTxn(() async {
      await _isar.offlinePaymentMethods.delete(id);
    });
  }
}