import 'package:isar/isar.dart';

part 'sync_metadata_model.g.dart';

@collection
class SyncMetadata {
  Id id = Isar.autoIncrement;

  String entityName = '';
  DateTime? lastSyncAt;
  int serverCount = 0;
  int localCount = 0;
  String syncStatus = 'idle';

  SyncMetadata();

  factory SyncMetadata.forEntity(String entityName) {
    return SyncMetadata()
      ..id = entityName.hashCode
      ..entityName = entityName;
  }
}