import 'package:flutter/material.dart';

typedef GestureTapCallback = void Function();

class ReadMoreText extends StatefulWidget {
  final String text;
  final int maxLength;
  final String readMoreText;
  final TextStyle? textStyle;

  final GestureTapCallback? onTap;

  const ReadMoreText({
    super.key,
    required this.text,
    required this.maxLength,
    this.readMoreText = '... Read more',
    this.textStyle,
    this.onTap,
  });

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  @override
  Widget build(BuildContext context) {
    String displayText =
        '${widget.text.substring(0, widget.maxLength)} \n\n${widget.readMoreText}';

    return GestureDetector(
      onTap: widget.onTap,
      child: Text(
        displayText,
        style: widget.textStyle,
      ),
    );
  }
}
