import 'package:flutter/material.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';

class MyBottomBar extends StatefulWidget {
  const MyBottomBar({
    super.key,
    required this.label,
    required this.onPressed,
    this.actions,
    this.hideBlockButton = false,
  });

  final List<MyBottomBarActions>? actions;
  final Widget label;
  final bool hideBlockButton;
  final void Function() onPressed;

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
    return Stack(
      children: [
        if (!widget.hideBlockButton)
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 8 / 100,
              child: MyFilledButton(
                onPressed: () {},
                child: const Icon(
                  Icons.block_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (!widget.hideBlockButton)
          Positioned(
            bottom: 0,
            right: MediaQuery.of(context).size.width * 8 / 100,
            child: SizedBox(
              height: 50,
              width: widget.actions != null
                  ? MediaQuery.of(context).size.width * 73 / 100
                  : MediaQuery.of(context).size.width * 92 / 100,
              child: MyFilledButton(
                onPressed: widget.onPressed,
                child: widget.label,
              ),
            ),
          ),
        if (widget.actions != null)
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
                      showActions ? Icons.close_rounded : Icons.list_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
