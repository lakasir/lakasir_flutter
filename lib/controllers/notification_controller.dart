import 'package:get/get.dart';
import 'package:lakasir/api/responses/notifications/notification_response.dart';
import 'package:lakasir/services/notification_service.dart';
import 'package:lakasir/utils/utils.dart';

class NotificationController extends GetxController {
  RxList<NotificationResponse> notifications = <NotificationResponse>[].obs;
  final NotificationService _notificationService = NotificationService();

  void fetch() async {
    var response = await _notificationService.get();

    notifications.value = response;
  }

  void create(NotificationRequest request) async {
    fetch();
  }

  void clear() async {
    await _notificationService.clear();
    fetch();
    show('notification_cleared'.tr);
  }

  void delete(NotificationResponse notification, int id) async {
    await _notificationService.delete(notification, id);
    fetch();
  }

  void createMany(List<NotificationRequest> request) {
    fetch();
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
