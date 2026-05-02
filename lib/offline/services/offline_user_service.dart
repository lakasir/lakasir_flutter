import 'package:isar/isar.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_user_model.dart';
import 'package:lakasir/utils/auth.dart';

class OfflineUserService {
  Future<OfflineUser> register({
    required String name,
    required String email,
    required String password,
    String? shopName,
    String? businessType,
  }) async {
    final isar = LakasirDatabase.isar;

    final existing = (await isar.offlineUsers
            .where()
            .filter()
            .emailEqualTo(email)
            .findAll())
        .firstOrNull;
    if (existing != null) {
      throw Exception('Email already exists');
    }

    final salt = OfflineUser.generateSalt();
    final hashedPassword = OfflineUser.hashPassword(password, salt);

    final user = OfflineUser()
      ..name = name
      ..email = email
      ..hashedPassword = hashedPassword
      ..salt = salt
      ..shopName = shopName ?? ''
      ..businessType = businessType ?? ''
      ..isOfflineUser = true
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.offlineUsers.put(user);
    });

    await storeOfflineAuth(true);
    await storeOfflineUserId(user.id);

    return user;
  }

  Future<OfflineUser> login({
    required String email,
    required String password,
  }) async {
    final isar = LakasirDatabase.isar;

    final user = (await isar.offlineUsers
            .where()
            .filter()
            .emailEqualTo(email)
            .findAll())
        .firstOrNull;

    if (user == null) {
      throw Exception('User not found');
    }

    if (!user.verifyPassword(password)) {
      throw Exception('Invalid password');
    }

    await storeOfflineAuth(true);
    await storeOfflineUserId(user.id);

    return user;
  }

  Future<OfflineUser?> getCurrentUser() async {
    final userId = await getOfflineUserId();
    if (userId == null) return null;

    final isar = LakasirDatabase.isar;
    return await isar.offlineUsers.get(userId);
  }

  Future<void> logout() async {
    await storeOfflineAuth(false);
  }

  Future<void> updateDomain(String domain) async {
    final user = await getCurrentUser();
    if (user == null) return;

    final isar = LakasirDatabase.isar;
    user.domain = domain;
    await isar.writeTxn(() async {
      await isar.offlineUsers.put(user);
    });
  }
}
