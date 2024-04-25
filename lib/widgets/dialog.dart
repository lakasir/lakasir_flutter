import 'package:flutter/material.dart';
import 'package:lakasir/utils/colors.dart';

class MyDialog extends StatefulWidget {
  const MyDialog({
    super.key,
    this.title,
    required this.content,
    this.noPadding = false,
    this.actions,
  });

  final String? title;
  final Widget content;
  final Widget? actions;
  final bool noPadding;

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      insetPadding: const EdgeInsets.all(0),
      surfaceTintColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        width: 0.9 * MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.title != null
                    ? Text(
                        widget.title!,
                        style: const TextStyle(fontSize: 18),
                      )
                    : const SizedBox(),
              ),
            if (widget.title != null)
              Container(
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: secondary),
                  borderRadius: BorderRadius.circular(12),
                  color: whiteGrey,
                ),
              ),
            if (!widget.noPadding)
              Padding(
                padding: const EdgeInsets.all(20),
                child: widget.content,
              ),
            if (widget.noPadding) widget.content,
            if (widget.noPadding && widget.actions != null) widget.actions!,
            if (!widget.noPadding && widget.actions != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: widget.actions,
              ),
          ],
        ),
      ),
    );
  }
}
