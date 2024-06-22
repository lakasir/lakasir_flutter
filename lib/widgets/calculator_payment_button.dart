import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';

class CalculatorPaymentButton extends StatefulWidget {
  const CalculatorPaymentButton({super.key, required this.onUpdated});
  final Function(String) onUpdated;

  @override
  State<StatefulWidget> createState() => _CalculatorPaymentButtonState();
}

class _CalculatorPaymentButtonState extends State<CalculatorPaymentButton> {
  List<CalculatorButton> buttons = [];
  List<CalculatorButton> shortcutButtons = [];
  ValueNotifier<String> values = ValueNotifier<String>("");
  final CartController _cartController = Get.put(CartController());
  bool isShorcutBefore = false;
  bool showTheShorcutButton = true;

  double totalPrice = 0;

  void _onPressed(String value, {bool shortcut = false}) {
    if (value == 'clear') {
      values.value = '0';
      widget.onUpdated('0');
      return;
    }
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
    if (shortcut) {
      values.value = value;
      widget.onUpdated(values.value);
    } else {
      if (isShorcutBefore) {
        values.value = value;
      } else {
        values.value += value;
      }

      debug(values.value);

      widget.onUpdated(values.value);
    }
    setState(() {
      isShorcutBefore = shortcut;
    });
  }

  List<double> generateSuggestedPayments(double totalPrice) {
    List<double> denominations = [
      1000,
      2000,
      5000,
      10000,
      20000,
      50000,
      100000
    ];
    List<double> suggestions = [];

    for (double denom in denominations) {
      double suggestion = ((totalPrice / denom).ceil()) * denom;
      if (!suggestions.contains(suggestion)) {
        suggestions.add(suggestion);
      }
    }

    suggestions.sort();

    if (!suggestions.contains(totalPrice) && totalPrice <= denominations.last) {
      suggestions.add(totalPrice);
    }

    // if (suggestions.length > 3) {
    //   suggestions = suggestions.sublist(0, 3);
    // }

    return suggestions;
  }

  void generateButton() {
    List<double> shortcutSuggestion = generateSuggestedPayments(totalPrice);
    for (var i = 0; i < shortcutSuggestion.length; i++) {
      var e = shortcutSuggestion[i];
      shortcutButtons.add(CalculatorButton(
        text: Text(formatPrice(e, isSymbol: false)),
        onPressed: () {
          _onPressed(e.toString(), shortcut: true);
        },
        color: whiteGrey,
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      totalPrice = _cartController.cartSessions.value.getTotalPrice;
    });

    generateButton();

    var b = [
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
        text: const Icon(Icons.delete_forever, size: 30),
        onPressed: () => _onPressed('clear'),
        color: whiteGrey,
      ),
    ];

    for (var i = 0; i < b.length; i++) {
      var e = b[i];
      buttons.add(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShortcutGridButton(buttons: shortcutButtons),
        NormalGridButton(buttons: buttons),
      ],
    );
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
    return MaterialButton(
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
        mainAxisExtent: 100,
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
        crossAxisCount: 4,
        mainAxisExtent: 50,
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
