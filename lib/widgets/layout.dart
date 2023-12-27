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
    this.baseHeight,
  });
  final Widget child;
  final Widget? bottomNavigationBar;
  final bool backButton;
  final String title;
  final Widget? bottomSheet;
  final bool noAppBar;
  final bool noPadding;
  final double padding;
  final double? baseHeight;

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
    final height = MediaQuery.of(context).size.height;
    double baseHeight = height * 77 / 100;
    if (widget.bottomNavigationBar == null) {
      baseHeight = double.infinity;
    }
    if (widget.baseHeight != null) {
      baseHeight = widget.baseHeight!;
    }

    return Scaffold(
      appBar: widget.noAppBar
          ? null
          : AppBar(
              automaticallyImplyLeading: widget.backButton,
              title: Center(
                child: Text(widget.title),
              ),
            ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        height: baseHeight,
        child: widget.noPadding
            ? widget.child
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.padding),
                child: widget.child,
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      resizeToAvoidBottomInset: false,
    );
  }
}
