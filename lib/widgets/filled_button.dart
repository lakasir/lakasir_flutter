import 'package:flutter/material.dart';
import 'package:lakasir/utils/colors.dart';

class MyFilledButton extends StatefulWidget {
  final bool? isLoading;
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;

  const MyFilledButton({
    super.key,
    this.isLoading = false,
    required this.onPressed,
    required this.child,
    this.color = primary,
  });

  @override
  State<StatefulWidget> createState() => _MyFilledButton();
}

class _MyFilledButton extends State<MyFilledButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // margin: const EdgeInsets.only(bottom: 40.0),
      width: double.infinity,
      child: FilledButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(widget.color!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.child,
              Visibility(
                visible: widget.isLoading!,
                child: const SizedBox(width: 10),
              ),
              Visibility(
                visible: widget.isLoading!,
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(primary),
                    strokeWidth: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
