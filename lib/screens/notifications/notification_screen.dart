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
              for (var nf in _notificationController.notifications)
                for (var notification in nf.data!)
                  Column(
                    children: [
                      MyCardList(
                        onTap: () {
                          if (notification.route != null) {
                            Get.toNamed(
                              notification.route.toString(),
                              arguments: notification.id.toString(),
                            );
                          }
                        },
                        list: [
                          Text(
                            notification.name!,
                          ),
                          Text(
                            notification.stock!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('EEEE')
                                    .format(
                                        DateTime.parse(nf.createdAt!).toLocal())
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                DateFormat('HH:mm')
                                    .format(
                                        DateTime.parse(nf.createdAt!).toLocal())
                                    .toString(),
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
