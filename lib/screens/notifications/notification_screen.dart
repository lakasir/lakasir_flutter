import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lakasir/controllers/notification_controller.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController _notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    _notificationController.fetch();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _notificationController.fetch();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'menu_notification'.tr,
      child: Obx(
        () {
          if (_notificationController.notifications.isEmpty) {
            // return Container();
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text('global_no_item'.trParams(
                      {
                        'item': 'menu_notification'.tr,
                      },
                    )),
                  ),
                ),
              ],
            );
          }
          return ListView(
            children: [
              for (var notification in _notificationController.notifications)
                Column(
                  children: [
                    MyCardList(
                      onTap: () {
                        if (notification.route != null) {
                          var route = jsonDecode(notification.route!);
                          Get.toNamed(
                            route['route'],
                            arguments: route['arguments'],
                          );
                          _notificationController.delete(notification);
                        }
                      },
                      list: [
                        Text(
                          notification.title!,
                        ),
                        Text(
                          notification.body!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat(
                                'EEEE',
                                Get.deviceLocale!.toString(),
                              ).format(
                                notification.createdAt ?? DateTime.now(),
                              ),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              DateFormat('HH:mm').format(
                                notification.createdAt ?? DateTime.now(),
                              ),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              if (_notificationController.notifications.isNotEmpty)
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      _notificationController.clear();
                    },
                    child: const Text(
                      'Clear All Notification',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
