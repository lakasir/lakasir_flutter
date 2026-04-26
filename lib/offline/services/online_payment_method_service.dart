import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:lakasir/api/responses/payment_methods/payment_method_response.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_payment_method_model.dart';
import 'package:lakasir/offline/services/payment_method_service_interface.dart';
import 'package:lakasir/services/payment_method_service.dart' as api;

class OnlinePaymentMethodService implements PaymentMethodServiceInterface {
  final _isar = LakasirDatabase.isar;
  final _apiService = api.PaymentMethodService();

  @override
  Future<List<OfflinePaymentMethod>> getPaymentMethods() async {
    try {
      final response = await _apiService.get();
      await _cachePaymentMethods(response);
    } catch (_) {
      // Silently fall back to cache on API failure
    }

    return await _getCachedPaymentMethods();
  }

  @override
  Future<OfflinePaymentMethod?> getPaymentMethodById(int id) async {
    return await _isar.offlinePaymentMethods.get(id);
  }

  @override
  Future<OfflinePaymentMethod> createPaymentMethod(OfflinePaymentMethod paymentMethod) async {
    paymentMethod
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

  Future<void> _cachePaymentMethods(RxList<PaymentMethodRespone> methods) async {
    final cached = methods.map((m) {
      return OfflinePaymentMethod()
        ..remoteId = m.id
        ..name = m.name
        ..icon = m.icon
        ..isCash = m.isCash
        ..isDebit = m.isDebit
        ..isCredit = m.isCredit
        ..isWallet = m.isWallet
        ..cachedAt = DateTime.now()
        ..isLocal = false;
    }).toList();

    await _isar.writeTxn(() async {
      await _isar.offlinePaymentMethods.putAll(cached);
    });
  }

  Future<List<OfflinePaymentMethod>> _getCachedPaymentMethods() async {
    return await _isar.offlinePaymentMethods.where().findAll();
  }
}