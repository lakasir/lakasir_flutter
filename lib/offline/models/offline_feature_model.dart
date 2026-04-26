import 'package:isar/isar.dart';

part 'offline_feature_model.g.dart';

@collection
class OfflineFeature {
  Id id = Isar.autoIncrement;

  String name = '';
  bool enabled = true;

  OfflineFeature();
}