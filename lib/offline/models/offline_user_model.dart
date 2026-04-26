import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';
import 'dart:convert';

part 'offline_user_model.g.dart';

@collection
class OfflineUser {
  Id id = Isar.autoIncrement;

  String name = '';
  String email = '';
  String hashedPassword = '';
  String salt = '';
  String shopName = '';
  String businessType = '';
  String? domain;
  bool isOfflineUser = true;
  DateTime createdAt = DateTime.now();
  DateTime? lastSyncAt;

  OfflineUser();

  static String generateSalt() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(999999);
    return '$timestamp$random';
  }

  static String hashPassword(String password, String salt) {
    final bytes = utf8.encode('$password$salt');
    return sha256.convert(bytes).toString();
  }

  bool verifyPassword(String password) {
    return hashPassword(password, salt) == hashedPassword;
  }
}