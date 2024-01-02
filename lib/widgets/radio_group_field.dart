import 'package:flutter/material.dart';
import 'package:lakasir/utils/colors.dart';

class MyRadioGroup extends StatefulWidget {
  const MyRadioGroup({
    super.key,
    required this.options,
    required this.onSelected,
    this.defaultSelectedValue = '',
  });
  final List<RadioOption> options;
  final Function(String) onSelected;
  final String defaultSelectedValue;

  @override
  State<MyRadioGroup> createState() => _MyRadioGroupState();
}

class _MyRadioGroupState extends State<MyRadioGroup> {
  String selectedValue = '';

  @override
  void initState() {
    super.initState();
    if (widget.defaultSelectedValue != '') {
      selectedValue = widget.defaultSelectedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        for (final option in widget.options)
          Row(
            children: [
              Container(
                width: 20,
                margin: const EdgeInsets.only(right: 10),
                child: Radio<String>(
                  toggleable: true,
                  fillColor: MaterialStateProperty.all(primary),
                  value: option.value,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value ?? "";
                    });
                    widget.onSelected(value!);
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedValue = option.value;
                  });
                  widget.onSelected(option.value);
                },
                child: Text(option.label),
              ),
            ],
          ),
      ],
    );
  }
}

class RadioOption {
  final String label;
  final String value;

  RadioOption({required this.label, required this.value});
}

class MyRadioGroupController {
  String selectedValue = '';
  void setSelectedValue(String value) {
    selectedValue = value;
  }
}
