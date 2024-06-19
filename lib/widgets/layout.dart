import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/notification_controller.dart';
import 'package:lakasir/utils/colors.dart';

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
    this.floatingActionButtonLocation = FloatingActionButtonLocation.endFloat,
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
  final FloatingActionButtonLocation floatingActionButtonLocation;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final NotificationController _controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    var shouldHide = ['/menu/setting/notification', '/notifications']
        .contains(Get.currentRoute);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: widget.noAppBar
          ? null
          : AppBar(
              backgroundColor: Colors.grey[100],
              automaticallyImplyLeading: widget.backButton,
              title: Container(
                margin: EdgeInsets.only(left: !shouldHide ? 50 : 0),
                child: Center(
                  child: Text(widget.title),
                ),
              ),
              actions: [
                if (Get.previousRoute != '/notifications')
                  if (!shouldHide)
                    IconButton(
                      icon: Obx(
                        () => Badge(
                          isLabelVisible: _controller.notifications.isNotEmpty,
                          child: const Icon(Icons.notifications),
                        ),
                      ),
                      onPressed: () => Get.toNamed('/notifications'),
                    )
              ],
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
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButton: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
    );
  }
}
