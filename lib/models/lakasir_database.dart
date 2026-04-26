import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:lakasir/models/printer.dart';
import 'package:lakasir/models/unit.dart';
import 'package:lakasir/offline/models/offline_user_model.dart';
import 'package:lakasir/offline/models/offline_category_model.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';
import 'package:lakasir/offline/models/offline_stock_model.dart';
import 'package:lakasir/offline/models/offline_member_model.dart';
import 'package:lakasir/offline/models/offline_payment_method_model.dart';
import 'package:lakasir/offline/models/offline_permission_model.dart';
import 'package:lakasir/offline/models/offline_feature_model.dart';
import 'package:lakasir/offline/models/pending_transaction_model.dart';
import 'package:lakasir/offline/models/cart_model.dart';
import 'package:lakasir/offline/models/sync_metadata_model.dart';
import 'package:path_provider/path_provider.dart';

class LakasirDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    var instance = Isar.getInstance("isar");

    if (instance == null) {
      isar = await Isar.open(
        [PrinterSchema, UnitSchema, OfflineUserSchema, OfflineCategorySchema, OfflineProductSchema, OfflineStockSchema, OfflineMemberSchema, OfflinePaymentMethodSchema, OfflinePermissionSchema, OfflineFeatureSchema, OfflinePendingTransactionSchema, OfflineCartSchema, SyncMetadataSchema],
        directory: dir.path,
        name: 'isar',
      );
    }
  }

  Unit get unit {
    return Unit(isar: isar);
  }

  Printer get printer {
    return Printer(isar: isar);
  }

  OfflineUser get offlineUser {
    return OfflineUser();
  }

  OfflineCategory get offlineCategory {
    return OfflineCategory();
  }

  OfflineProduct get offlineProduct {
    return OfflineProduct();
  }

  OfflineStock get offlineStock {
    return OfflineStock();
  }

  OfflineMember get offlineMember {
    return OfflineMember();
  }

  OfflinePaymentMethod get offlinePaymentMethod {
    return OfflinePaymentMethod();
  }

  OfflinePendingTransaction get offlinePendingTransaction {
    return OfflinePendingTransaction();
  }

  OfflineCart get offlineCart {
    return OfflineCart();
  }

  SyncMetadata get syncMetadata {
    return SyncMetadata();
  }
}
