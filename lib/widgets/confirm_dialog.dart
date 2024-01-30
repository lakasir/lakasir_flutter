import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyConfirmDialog extends StatelessWidget {
  const MyConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.onCancel,
    this.confirmText,
    this.cancelText,
  });

  final String title;
  final Widget content;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String? confirmText;
  final String? cancelText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: [
        TextButton(
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Text(cancelText ?? "global_cancel".tr),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(confirmText ?? "global_confirm".tr),
        ),
      ],
    );
  }
}
