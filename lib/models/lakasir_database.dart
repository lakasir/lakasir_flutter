import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:lakasir/models/printer.dart';
import 'package:lakasir/models/unit.dart';
import 'package:path_provider/path_provider.dart';

class LakasirDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    var instance = Isar.getInstance("isar");

    if (instance == null) {
      isar = await Isar.open(
        [PrinterSchema, UnitSchema],
        directory: dir.path,
        name: 'isar',
      );
    }
  }

  Unit get unit {
    return Unit(isar: isar);
  }

  Printer get printer {
    return Printer(isar: isar);
  }
}
