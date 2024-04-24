import 'dart:io';

import 'package:isar/isar.dart';

part 'printer.g.dart';

@collection
class Printer {
  Id id = Isar.autoIncrement;

  String? name;
  String? logopath;
  String? address;
  String? footer;

  @ignore
  final Isar? isar;

  Printer({this.isar});

  Future<List<Printer>> fetch() async {
    final results = await isar!.printers.where().findAll();

    return results;
  }

  Future<void> create(Printer printer) async {
    await isar!.writeTxn(() => isar!.printers.put(printer));

    fetch();
  }

  Future<void> delete(Printer printer) async {
    // how to delete the logo path from local path

    if (printer.logopath != null) File(printer.logopath!).delete();
    await isar!.writeTxn(() => isar!.printers.delete(printer.id));
    fetch();
  }
}
