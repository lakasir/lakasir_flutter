import 'package:isar/isar.dart';

part 'offline_category_model.g.dart';

@collection
class OfflineCategory {
  Id id = Isar.autoIncrement;

  String name = '';
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? cachedAt;
  bool isLocal = false;

  OfflineCategory();
}