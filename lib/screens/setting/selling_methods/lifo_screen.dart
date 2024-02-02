import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class LifoScreen extends StatelessWidget {
  const LifoScreen({super.key, this.isEnable = false, this.onChanged});

  final bool isEnable;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          "lifo_info".tr,
        ),
        const SizedBox(height: 10),
        Text(
          "lifo_price_info".tr,
        ),
        MyCardList(list: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("global_enable_it".tr),
              Switch(
                value: isEnable,
                onChanged: onChanged,
              ),
            ],
          ),
        ])
      ],
    );
  }
}
