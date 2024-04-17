import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:lakasir/models/printer.dart';
import 'package:lakasir/models/unit.dart';
import 'package:path_provider/path_provider.dart';

class LakasirDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [PrinterSchema, UnitSchema],
      directory: dir.path,
    );
  }

  Future<List<Printer>> fetchPrinters() async {
    final results = await isar.printers.where().findAll();
    return results;
  }

  Future<void> createPrinters(Printer printer) async {
    await isar.writeTxn(() => isar.printers.put(printer));

    fetchPrinters();
  }

  Future<void> deletePrinters(Printer printer) async {
    // how to delete the logo path from local path

    if (printer.logopath != null) File(printer.logopath!).delete();
    await isar.writeTxn(() => isar.printers.delete(printer.id));
    fetchPrinters();
  }

  Future<List<Unit>> fetchUnits() async {
    final results =
        await isar.units.where().sortByUpdatedAtDesc().limit(3).findAll();
    return results;
  }

  Future<void> createOrUpdateUnit(Unit unit) async {
    await isar.writeTxn(() async {
      var existingUnit =
          (await isar.units.where().filter().nameEqualTo(unit.name).findAll())
              .firstOrNull;
      existingUnit?.updatedAt = unit.updatedAt;
      await isar.units.put(existingUnit ?? unit);
    });
  }

  Future<void> clearUnits() async {
    await isar.writeTxn(() async {
      final results = await isar.units.where().findAll();
      await isar.units.deleteAll(results.map((e) => e.id).toList());
    });
  }
}
