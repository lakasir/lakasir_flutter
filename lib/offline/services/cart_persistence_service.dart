import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/cart_model.dart';
import 'package:lakasir/offline/models/offline_member_model.dart';
import 'package:lakasir/offline/models/offline_payment_method_model.dart';
import 'package:lakasir/offline/models/offline_product_model.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';

class CartPersistenceService {
  static const _sessionKey = 'cart_session_meta';

  Future<void> saveCart(CartSession session) async {
    final isar = LakasirDatabase.isar;

    // Save cart items to Isar
    await isar.writeTxn(() async {
      await isar.offlineCarts.clear();
      for (final item in session.cartItems) {
        final cart = OfflineCart()
          ..productId = item.product.id
          ..quantity = item.qty
          ..price = item.product.sellingPrice ?? 0
          ..discountPrice = item.discountPrice
          ..addedAt = DateTime.now();
        await isar.offlineCarts.put(cart);
      }
    });

    // Save session metadata to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final meta = {
      'tax': session.tax,
      'note': session.note,
      'friendPrice': session.friendPrice,
      'customerNumber': session.customerNumber,
      'memberId': session.member?.id,
      'paymentMethodId': session.paymentMethod?.id,
    };
    await prefs.setString(_sessionKey, jsonEncode(meta));
  }

  Future<CartSession?> loadCart() async {
    final isar = LakasirDatabase.isar;
    final prefs = await SharedPreferences.getInstance();

    // Load cart items from Isar
    final carts = await isar.offlineCarts.where().findAll();
    if (carts.isEmpty) return null;

    final cartItems = <CartItem>[];
    for (final cart in carts) {
      final product = await isar.offlineProducts.get(cart.productId);
      if (product == null) continue;
      cartItems.add(CartItem(
        product: product,
        qty: cart.quantity,
        discountPrice: cart.discountPrice,
      ));
    }

    if (cartItems.isEmpty) return null;

    // Load session metadata
    final metaStr = prefs.getString(_sessionKey);
    double? tax;
    String? note;
    bool friendPrice = false;
    int? customerNumber;
    OfflineMember? member;
    OfflinePaymentMethod? paymentMethod;

    if (metaStr != null) {
      final meta = jsonDecode(metaStr) as Map<String, dynamic>;
      tax = (meta['tax'] as num?)?.toDouble();
      note = meta['note'] as String?;
      friendPrice = meta['friendPrice'] as bool? ?? false;
      customerNumber = meta['customerNumber'] as int?;
      final memberId = meta['memberId'] as int?;
      final paymentMethodId = meta['paymentMethodId'] as int?;
      if (memberId != null) {
        member = await isar.offlineMembers.get(memberId);
      }
      if (paymentMethodId != null) {
        paymentMethod =
            await isar.offlinePaymentMethods.get(paymentMethodId);
      }
    }

    return CartSession(
      cartItems: cartItems,
      tax: tax,
      note: note,
      friendPrice: friendPrice,
      customerNumber: customerNumber,
      member: member,
      paymentMethod: paymentMethod,
    );
  }

  Future<void> clearCart() async {
    final isar = LakasirDatabase.isar;
    final prefs = await SharedPreferences.getInstance();
    await isar.writeTxn(() async {
      await isar.offlineCarts.clear();
    });
    await prefs.remove(_sessionKey);
  }
}