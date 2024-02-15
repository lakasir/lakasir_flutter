import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCardList extends StatefulWidget {
  const MyCardList({
    super.key,
    required this.list,
    this.imagebox,
    this.route,
    this.onTap,
    this.trailing,
    this.enableFeedback = true,
  });
  final String? route;
  final List<Widget> list;
  final Widget? imagebox;
  final Widget? trailing;
  final Function? onTap;
  final bool enableFeedback;

  @override
  State<MyCardList> createState() => _MyCardListState();
}

class _MyCardListState extends State<MyCardList> {
  @override
  Widget build(BuildContext context) {
    double marginLeft = MediaQuery.of(context).size.width * 4 / 100;
    if (widget.imagebox == null) {
      marginLeft = 0;
    }
    return InkWell(
      splashColor: widget.enableFeedback
          ? Get.theme.primaryColor.withOpacity(0.12)
          : Colors.transparent,
      splashFactory: widget.enableFeedback
          ? InkRipple.splashFactory
          : NoSplash.splashFactory,
      onLongPress: () {},
      enableFeedback: widget.enableFeedback,
      onTap: () {
        if (widget.route != null) {
          Get.toNamed(widget.route as String);
        }
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            if (widget.imagebox != null) widget.imagebox!,
            Flexible(
              child: Container(
                margin: EdgeInsets.only(
                  left: marginLeft,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.list,
                ),
              ),
            ),
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );
  }
}
