import 'package:isar/isar.dart';

part 'printer.g.dart';

@collection
class Printer {
  Id id = Isar.autoIncrement;

  String? name;
  String? logopath;
  String? address;
  String? footer;
}
