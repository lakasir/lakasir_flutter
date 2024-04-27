import 'package:isar/isar.dart';

part 'notification.g.dart';

@collection
class NotificationModel {
  Id id = Isar.autoIncrement;

  String? title;
  String? body;
  String? data;
  bool? isReaded;
  DateTime? createdAt;
  String? route;

  @ignore
  final Isar? isar;

  NotificationModel({this.isar});

  Future<List<NotificationModel>> fetch() async {
    final results = await isar!.notificationModels.where().findAll();

    return results;
  }

  void create(NotificationModel notification) async {
    await isar!.writeTxn(() => isar!.notificationModels.put(notification));
  }

  Future<void> clear() async {
    await isar!.writeTxn(() async {
      final results = await isar!.notificationModels.where().findAll();
      await isar!.notificationModels
          .deleteAll(results.map((e) => e.id).toList());
    });
  }

  void delete(NotificationModel notification) async {
    await isar!.writeTxn(() async {
      await isar!.notificationModels.delete(notification.id);
    });
  }
}
