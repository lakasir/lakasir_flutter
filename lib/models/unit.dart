import 'package:isar/isar.dart';

part 'unit.g.dart';

@collection
class Unit {
  Id id = Isar.autoIncrement;

  String? name;
  DateTime? updatedAt;
}
