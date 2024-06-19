import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';

class MyBottomBar extends StatefulWidget {
  const MyBottomBar({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.actions,
    this.hideBlockButton = false,
  });

  final List<MyBottomBarActions>? actions;
  final IconData icon;
  final Widget label;
  final bool hideBlockButton;
  final void Function()? onPressed;

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  bool showActions = false;

  void toggleActionsVisibility() {
    setState(() {
      showActions = !showActions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            if (widget.actions != null)
              SpeedDial(
                icon: Icons.list_rounded,
                activeIcon: Icons.close,
                backgroundColor: primary,
                foregroundColor: whiteGrey,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                children: [
                  if (widget.actions != null)
                    for (var action in widget.actions!)
                      SpeedDialChild(
                        child: action.icon,
                        backgroundColor: error,
                        label: action.label,
                        onTap: action.onPressed,
                      ),
                ],
              ),
            if (widget.actions == null) _withOutAction(),
            if (widget.actions != null) _withAction(),
          ],
        );
      },
    );
  }

  FloatingActionButton _withOutAction() {
    return FloatingActionButton.extended(
      backgroundColor: primary,
      foregroundColor: whiteGrey,
      onPressed: widget.onPressed,
      label: widget.label,
      icon: Icon(widget.icon),
    );
  }

  Padding _withAction() {
    return Padding(
      padding: const EdgeInsets.only(
        right: 7.5,
        bottom: 70,
      ),
      child: SizedBox(
        height: 40,
        width: 40,
        child: Center(
          child: FloatingActionButton(
            backgroundColor: whiteGrey,
            foregroundColor: primary,
            onPressed: widget.onPressed,
            child: Icon(widget.icon),
          ),
        ),
      ),
    );
  }
}

/* Stack(
children: [
  if (!widget.hideBlockButton)
    Positioned(
      bottom: 0,
      right: MediaQuery.of(context).size.width * 30 / 100,
      child: SizedBox(
        height: 50,
        width: widget.actions != null || widget.singleAction!
            ? MediaQuery.of(context).size.width * 73 / 100
            : MediaQuery.of(context).size.width * 92 / 100,
        child: widget.label != null
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 1,
                      spreadRadius: -5,
                      offset: const Offset(-3, 7),
                      blurStyle: BlurStyle.normal,
                    ),
                  ],
                ),
                child: MyFilledButton(
                  onPressed: widget.onPressed!,
                  child: widget.label ?? Container(),
                ),
              )
            : null,
      ),
    ),
  if (widget.actions != null || widget.singleAction!)
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: showActions
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var action in widget.actions!)
                      MyBottomBarActions(
                        onPressed: () {
                          action.onPressed();
                          toggleActionsVisibility();
                        },
                        label: action.label!,
                        icon: action.icon!,
                      ),
                  ],
                )
              : Visibility(visible: true, child: Container()),
        ),
        Container(
          margin: const EdgeInsets.only(top: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 1,
                spreadRadius: -5,
                offset: const Offset(-6, 7),
                blurStyle: BlurStyle.normal,
              ),
            ],
          ),
          child: TextButton(
            onPressed: toggleActionsVisibility,
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
              overlayColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
              padding: MaterialStateProperty.all(
                EdgeInsets.zero,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: primary,
              ),
              child: Icon(
                getIcon(),
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    ),
],
) */
