import 'package:flutter/material.dart';

class MyCardList extends StatefulWidget {
  const MyCardList({
    super.key,
    required this.list,
    this.imagebox,
    this.route,
    this.onTap,
  });
  final String? route;
  final List<Widget> list;
  final Widget? imagebox;
  final Function? onTap;

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
    return GestureDetector(
      onLongPress: () {},
      onTap: () {
        if (widget.route != null) {
          Navigator.pushNamed(context, widget.route as String);
        }
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            widget.imagebox ?? const SizedBox(),
            Container(
              margin: EdgeInsets.only(
                left: marginLeft,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.list,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
