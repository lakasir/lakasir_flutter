import 'package:flutter/material.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';

class CalculatorPaymentButton extends StatefulWidget {
  const CalculatorPaymentButton({super.key, required this.onUpdated});
  final Function(String) onUpdated;

  @override
  State<StatefulWidget> createState() => _CalculatorPaymentButtonState();
}

class _CalculatorPaymentButtonState extends State<CalculatorPaymentButton> {
  bool isShowNormal = true;
  List<CalculatorButton> buttons = [];
  List<CalculatorButton> shortcutButtons = [];
  ValueNotifier<String> values = ValueNotifier<String>("");

  void _onPressed(String value) {
    if (value == 'backspace') {
      if (values.value.length == 1) {
        widget.onUpdated('0');
      }
      if (values.value.isNotEmpty) {
        values.value = values.value.substring(0, values.value.length - 1);
        widget.onUpdated(values.value);
      }
      if (values.value.isEmpty) {
        widget.onUpdated('0');
      }
      if (values.value == '0') {
        widget.onUpdated('0');
      }
      return;
    }
    if (!isShowNormal) {
      values.value = value;
      widget.onUpdated(values.value);
      return;
    }
    values.value += value;
    widget.onUpdated(values.value);
  }

  @override
  void initState() {
    super.initState();
    buttons = [
      CalculatorButton(
          text: const Text('7'),
          onPressed: () {
            _onPressed('7');
          },
          color: whiteGrey),
      CalculatorButton(
          text: const Text('8'),
          onPressed: () {
            _onPressed('8');
          },
          color: whiteGrey),
      CalculatorButton(
          text: const Text('9'),
          onPressed: () {
            _onPressed('9');
          },
          color: whiteGrey),
      CalculatorButton(
          text: const Text('4'),
          onPressed: () {
            _onPressed('4');
          },
          color: whiteGrey),
      CalculatorButton(
          text: const Text('5'),
          onPressed: () {
            _onPressed('5');
          },
          color: whiteGrey),
      CalculatorButton(
          text: const Text('6'),
          onPressed: () {
            _onPressed('6');
          },
          color: whiteGrey),
      CalculatorButton(
          text: const Text('1'),
          onPressed: () {
            _onPressed('1');
          },
          color: whiteGrey),
      CalculatorButton(
          text: const Text('2'),
          onPressed: () {
            _onPressed('2');
          },
          color: whiteGrey),
      CalculatorButton(
          text: const Text('3'),
          onPressed: () {
            _onPressed('3');
          },
          color: whiteGrey),
      CalculatorButton(
        text: const Icon(Icons.backspace, size: 30),
        onPressed: () {
          _onPressed('backspace');
        },
        color: whiteGrey,
      ),
      CalculatorButton(
          text: const Text('0'),
          onPressed: () {
            _onPressed('0');
          },
          color: whiteGrey),
      CalculatorButton(
        text: const Icon(Icons.keyboard_hide, size: 30),
        onPressed: () {
          setState(() {
            isShowNormal = false;
          });
        },
        color: whiteGrey,
      ),
    ];
    shortcutButtons = [
      CalculatorButton(
          text: Text(formatPrice(100000, isSymbol: false)),
          onPressed: () {
            _onPressed('100000');
          },
          color: whiteGrey),
      CalculatorButton(
          text: Text(formatPrice(60000, isSymbol: false)),
          onPressed: () {
            _onPressed('60000');
          },
          color: whiteGrey),
      CalculatorButton(
          text: Text(formatPrice(50000, isSymbol: false)),
          onPressed: () {
            _onPressed('50000');
          },
          color: whiteGrey),
      CalculatorButton(
          text: Text(formatPrice(40000, isSymbol: false)),
          onPressed: () {
            _onPressed('40000');
          },
          color: whiteGrey),
      CalculatorButton(
          text: Text(formatPrice(30000, isSymbol: false)),
          onPressed: () {
            _onPressed('30000');
          },
          color: whiteGrey),
      CalculatorButton(
          text: Text(formatPrice(10000, isSymbol: false)),
          onPressed: () {
            _onPressed('10000');
          },
          color: whiteGrey),
      CalculatorButton(
        text: const Icon(Icons.backspace, size: 30),
        onPressed: () {
          _onPressed('backspace');
        },
        color: whiteGrey,
      ),
      CalculatorButton(
          text: Text(formatPrice(5000, isSymbol: false)),
          onPressed: () {
            _onPressed('5000');
          },
          color: whiteGrey),
      CalculatorButton(
        text: const Icon(Icons.keyboard, size: 30),
        onPressed: () {
          setState(() {
            isShowNormal = true;
          });
        },
        color: whiteGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return isShowNormal
        ? NormalGridButton(buttons: buttons)
        : ShortcutGridButton(buttons: shortcutButtons);
  }
}

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.white,
    this.textColor = Colors.black,
  });

  final Widget text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final TextStyle textStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      height: 105,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
      ),
      child: MaterialButton(
        padding: const EdgeInsets.all(8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        onPressed: onPressed,
        child: text is Text
            ? Text(
                (text as Text).data.toString(),
                style: textStyle,
              )
            : text,
      ),
    );
  }
}

class NormalGridButton extends StatelessWidget {
  const NormalGridButton({
    super.key,
    required this.buttons,
  });

  final List<CalculatorButton> buttons;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: buttons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(3),
          child: Center(child: buttons[index]),
        );
      },
    );
  }
}

class ShortcutGridButton extends StatelessWidget {
  const ShortcutGridButton({
    super.key,
    required this.buttons,
  });

  final List<CalculatorButton> buttons;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: buttons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(3),
          child: Center(child: buttons[index]),
        );
      },
    );
  }
}
