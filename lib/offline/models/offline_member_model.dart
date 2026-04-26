import 'package:isar/isar.dart';

part 'offline_member_model.g.dart';

@collection
class OfflineMember {
  Id id = Isar.autoIncrement;

  int? remoteId;
  String name = '';
  String? code;
  String? address;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? cachedAt;
  bool isLocal = false;

  OfflineMember();
}