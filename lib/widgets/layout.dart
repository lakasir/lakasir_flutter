import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({
    super.key,
    required this.child,
    this.bottomNavigationBar,
    this.backButton = false,
    this.title = 'Menu',
    this.bottomSheet,
    this.noAppBar = false,
    this.noPadding = false,
    this.padding = 20,
    this.baseHeight = 0,
    this.resizeToAvoidBottomInset = false,
  });
  final Widget child;
  final Widget? bottomNavigationBar;
  final bool backButton;
  final String title;
  final Widget? bottomSheet;
  final bool noAppBar;
  final bool noPadding;
  final double padding;
  final double baseHeight;
  final bool resizeToAvoidBottomInset;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: widget.noAppBar
          ? null
          : AppBar(
              backgroundColor: Colors.grey[100],
              automaticallyImplyLeading: widget.backButton,
              title: Center(
                child: Text(widget.title),
              ),
            ),
      body: OrientationBuilder(builder: (context, orientation) {
        return SizedBox(
          // margin: const EdgeInsets.only(top: 20),
          width: double.infinity,
          // height: baseHeight,
          child: widget.noPadding
              ? widget.child
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.padding),
                  child: widget.child,
                ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
    );
  }
}
