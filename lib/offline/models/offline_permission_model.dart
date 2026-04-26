import 'package:isar/isar.dart';

part 'offline_permission_model.g.dart';

@collection
class OfflinePermission {
  Id id = Isar.autoIncrement;

  String name = '';

  OfflinePermission();
}