import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout(
      {super.key,
      required this.child,
      this.bottomNavigationBar,
      this.backButton = false,
      this.title = 'Menu',
      this.bottomSheet,
      this.noAppBar = false,
      this.noPadding = false,
      this.padding = 20});
  final Widget child;
  final Widget? bottomNavigationBar;
  final bool backButton;
  final String title;
  final Widget? bottomSheet;
  final bool noAppBar;
  final bool noPadding;
  final double padding;

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
        height: double.infinity,
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
