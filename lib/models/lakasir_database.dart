import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:lakasir/models/printer.dart';
import 'package:path_provider/path_provider.dart';

class LakasirDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [PrinterSchema],
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
    await isar.writeTxn(() => isar.printers.delete(printer.id));
    fetchPrinters();
  }
}
