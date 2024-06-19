import 'package:lakasir/api/responses/notifications/stock_runs_out_response.dart';

class NotificationResponse {
  String? uuid;
  String? type;
  List<dynamic>? data;
  String? createdAt;

  NotificationResponse({
    this.uuid,
    this.type,
    this.data,
    this.createdAt,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    dynamic data;
    if (json['type'] == 'App\\Notifications\\StockRunsOut') {
      data = json['data'] != null
          ? (json['data'] as List).map((e) => StockRunsOut.fromJson(e)).toList()
          : [];
    }
    return NotificationResponse(
      uuid: json['id'],
      type: json['type'],
      data: data,
      createdAt: json['created_at'],
    );
  }
}
