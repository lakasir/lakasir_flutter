import 'package:isar/isar.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_feature_model.dart';
import 'package:lakasir/offline/models/offline_permission_model.dart';

class OfflinePermissionService {
  static const List<String> defaultPermissions = [
    'read selling',
    'read product',
    'create product',
    'update product',
    'delete product',
    'read product stock',
    'create product stock',
    'delete product stock',
    'read detail initial price',
    'read category',
    'create category',
    'update category',
    'delete category',
    'read member',
    'create member',
    'update member',
    'delete member',
    'read about',
    'update about',
    'update currency',
    'close cash drawer',
    'set default tax',
    'set selling method',
    'enable cash drawer',
    'enable secure initial price',
    'verify secure initial price',
    'set the minimum stock notification',
  ];

  static const Map<String, bool> defaultFeatures = {
    'member': true,
    'product-sku': true,
    'product-barcode': true,
    'product-stock': true,
    'product-initial-price': true,
    'product-type': true,
    'product-expired': true,
    'payment-method': true,
  };

  Future<void> seedDefaultPermissions() async {
    final isar = LakasirDatabase.isar;

    final existingPermissions = await isar.offlinePermissions.count();
    if (existingPermissions > 0) return;

    final permissions = defaultPermissions.map((name) {
      return OfflinePermission()..name = name;
    }).toList();

    final features = defaultFeatures.entries.map((entry) {
      return OfflineFeature()
        ..name = entry.key
        ..enabled = entry.value;
    }).toList();

    await isar.writeTxn(() async {
      await isar.offlinePermissions.putAll(permissions);
      await isar.offlineFeatures.putAll(features);
    });
  }

  Future<List<String>> getPermissions() async {
    final isar = LakasirDatabase.isar;
    final permissions = await isar.offlinePermissions.where().findAll();
    return permissions.map((p) => p.name).toList();
  }

  Future<Map<String, bool>> getFeatures() async {
    final isar = LakasirDatabase.isar;
    final features = await isar.offlineFeatures.where().findAll();
    return {for (final f in features) f.name: f.enabled};
  }
}