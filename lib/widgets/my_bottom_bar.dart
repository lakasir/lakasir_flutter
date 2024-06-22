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
              Padding(
                padding: const EdgeInsets.only(
                  right: 7,
                  bottom: 70,
                ),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: SpeedDial(
                    icon: Icons.list_rounded,
                    activeIcon: Icons.close,
                    backgroundColor: whiteGrey,
                    foregroundColor: primary,
                    overlayColor: Colors.black,
                    overlayOpacity: 0.5,
                    children: [
                      if (widget.actions != null)
                        for (var action in widget.actions!)
                          SpeedDialChild(
                            child: action.icon,
                            backgroundColor: error,
                            label: action.badge,
                            onTap: action.onPressed,
                          ),
                    ],
                  ),
                ),
              ),
            if (widget.actions == null) _withOutAction(),
            if (widget.actions != null) _withAction(),
          ],
        );
      },
    );
  }

  Widget _withOutAction() {
    return FloatingActionButton.extended(
      backgroundColor: primary,
      foregroundColor: whiteGrey,
      onPressed: widget.onPressed,
      label: widget.label,
      icon: Icon(widget.icon),
    );
  }

  Widget _withAction() {
    return Padding(
      padding: const EdgeInsets.only(),
      child: FloatingActionButton.extended(
        backgroundColor: primary,
        foregroundColor: whiteGrey,
        onPressed: widget.onPressed,
        label: widget.label,
        icon: Icon(widget.icon),
      ),
    );
  }
}
