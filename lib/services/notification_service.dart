import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/notifications/notification_response.dart';
import 'package:lakasir/utils/auth.dart';

class NotificationService {
  Future<List<NotificationResponse>> get() async {
    final response = await ApiService(await getDomain()).fetchData(
      'notification',
    );

    final apiResponse = ApiResponse.fromJsonList(response, (contentJson) {
      return List<NotificationResponse>.from(
          contentJson.map((x) => NotificationResponse.fromJson(x)));
    });

    return apiResponse.data?.value ?? [];
  }

  Future<void> clear() async {
    await ApiService(await getDomain()).deleteData(
      'notification/clear',
    );
  }

  Future<void> delete(NotificationResponse notification, int id) async {
    await ApiService(await getDomain()).putData(
      'notification/${notification.uuid}/$id',
      {},
    );
  }
}
