import 'package:get/get.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/sync_metadata_model.dart';
import 'package:lakasir/offline/repositories/category_repository.dart';
import 'package:lakasir/offline/repositories/member_repository.dart';
import 'package:lakasir/offline/repositories/payment_method_repository.dart';
import 'package:lakasir/offline/repositories/product_repository.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/offline/services/transaction_queue_service.dart';

class SyncService extends GetxController {
  final RxBool isSyncing = false.obs;
  final RxString syncStatus = 'idle'.obs;
  final RxDouble syncProgress = 0.0.obs;
  final _isar = LakasirDatabase.isar;

  Future<void> fullSync() async {
    if (isSyncing.value) return;

    final appMode = Get.find<AppModeService>();
    if (!appMode.isOnline) return;

    isSyncing.value = true;
    syncStatus.value = 'syncing';
    syncProgress.value = 0.0;

    try {
      // Step 1: Sync products (largest dataset)
      syncStatus.value = 'syncing_products';
      await _syncProducts();
      syncProgress.value = 0.4;

      // Step 2: Sync categories
      syncStatus.value = 'syncing_categories';
      await _syncCategories();
      syncProgress.value = 0.6;

      // Step 3: Sync members
      syncStatus.value = 'syncing_members';
      await _syncMembers();
      syncProgress.value = 0.8;

      // Step 4: Sync payment methods
      syncStatus.value = 'syncing_payment_methods';
      await _syncPaymentMethods();
      syncProgress.value = 0.9;

      // Step 5: Sync pending transactions
      syncStatus.value = 'syncing_transactions';
      await Get.find<TransactionQueueService>().attemptSync();
      syncProgress.value = 1.0;

      // Step 6: Update sync metadata
      await _updateSyncMetadata();

      syncStatus.value = 'completed';
    } catch (e) {
      syncStatus.value = 'failed';
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> _syncProducts() async {
    try {
      final repo = ProductRepository();
      await repo.getProducts();
      await _saveSyncTime('products');
    } catch (_) {
      // Continue with other syncs even if one fails
    }
  }

  Future<void> _syncCategories() async {
    try {
      final repo = CategoryRepository();
      await repo.getCategories();
      await _saveSyncTime('categories');
    } catch (_) {}
  }

  Future<void> _syncMembers() async {
    try {
      final repo = MemberRepository();
      await repo.getMembers();
      await _saveSyncTime('members');
    } catch (_) {}
  }

  Future<void> _syncPaymentMethods() async {
    try {
      final repo = PaymentMethodRepository();
      await repo.getPaymentMethods();
      await _saveSyncTime('payment_methods');
    } catch (_) {}
  }

  Future<void> _saveSyncTime(String entity) async {
    final meta = SyncMetadata.forEntity(entity)
      ..lastSyncAt = DateTime.now()
      ..syncStatus = 'completed';

    await _isar.writeTxn(() async {
      await _isar.syncMetadatas.put(meta);
    });
  }

  Future<void> _updateSyncMetadata() async {
    await _saveSyncTime('full_sync');
  }

  Future<DateTime?> getLastSyncTime(String entity) async {
    final meta = await _isar.syncMetadatas.get(entity.hashCode);
    return meta?.lastSyncAt;
  }
}