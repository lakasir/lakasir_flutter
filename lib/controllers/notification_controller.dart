import 'dart:convert';

import 'package:get/get.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/models/notification.dart';
import 'package:lakasir/utils/utils.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  void fetch() async {
    var results = await LakasirDatabase().notification.fetch();

    notifications.assignAll(results);
  }

  void create(NotificationRequest request) async {
    NotificationModel notification = fillModel(request);

    LakasirDatabase().notification.create(notification);

    fetch();
  }

  void clear() async {
    await LakasirDatabase().notification.clear();
    await show('Notification cleared');
    fetch();
  }

  void delete(NotificationModel notification) async {
    LakasirDatabase().notification.delete(notification);
    fetch();
  }

  void createMany(List<NotificationRequest> request) {
    for (var req in request) {
      NotificationModel notification = fillModel(req);

      LakasirDatabase().notification.create(notification);
    }
    fetch();
  }

  NotificationModel fillModel(NotificationRequest req) {
    var notification = NotificationModel()
      ..title = req.title
      ..body = req.body
      ..data = req.data
      ..isReaded = false
      ..route = jsonEncode({
        'route': '/menu/product/stock',
        'arguments': req.data,
      })
      ..createdAt = DateTime.now();

    return notification;
  }
}

class NotificationRequest {
  final String? title;
  final String? body;
  final String? data;

  NotificationRequest({
    this.title,
    this.body,
    this.data,
  });
}
