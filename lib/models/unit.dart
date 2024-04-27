import 'package:isar/isar.dart';

part 'unit.g.dart';

@collection
class Unit {
  Id id = Isar.autoIncrement;

  String? name;
  DateTime? updatedAt;

  @ignore
  final Isar? isar;

  Unit({this.isar});

  Future<List<Unit>> fetch() async {
    final results =
        await isar!.units.where().sortByUpdatedAtDesc().limit(3).findAll();
    return results;
  }

  Future<void> create(Unit unit) async {
    await isar!.writeTxn(() async {
      var existingUnit =
          (await isar!.units.where().filter().nameEqualTo(unit.name).findAll())
              .firstOrNull;
      existingUnit?.updatedAt = unit.updatedAt;
      await isar!.units.put(existingUnit ?? unit);
    });
  }

  Future<void> clear() async {
    await isar!.writeTxn(() async {
      final results = await isar!.units.where().findAll();
      await isar!.units.deleteAll(results.map((e) => e.id).toList());
    });
  }
}
