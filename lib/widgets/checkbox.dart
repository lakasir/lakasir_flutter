import 'package:flutter/material.dart';
import 'package:lakasir/utils/colors.dart';

typedef MyCallback = void Function(bool);

class MyCheckbox extends StatefulWidget {
  const MyCheckbox({super.key, this.label = "", required this.onChange});
  final String label;
  final MyCallback onChange;

  @override
  State<MyCheckbox> createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width * 80 / 100;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
        widget.onChange(isChecked);
      },
      child: Container(
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                border: Border.all(color: primary),
                borderRadius: BorderRadius.zero,
                color: isChecked ? primary : Colors.white,
              ),
              child: Icon(
                isChecked ? Icons.check : null,
                size: 16.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8.0),
            SizedBox(
              width: widthScreen.ceil().toDouble(),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }
}
