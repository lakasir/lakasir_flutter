import 'package:get/get.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/models/unit.dart';

class UnitController extends GetxController {
  RxList<Unit> units = <Unit>[].obs;

  void fetchUnits() async {
    var results = await LakasirDatabase().unit.fetch();

    units.assignAll(results);
  }

  void createOrUpdateUnit(String name) async {
    var unit = Unit()
      ..name = name
      ..updatedAt = DateTime.now();
    await LakasirDatabase().unit.create(unit);
    fetchUnits();
  }

  void clearUnit() async {
    await LakasirDatabase().unit.clear();
  }
}
