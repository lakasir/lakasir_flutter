import 'package:flutter/material.dart';
import 'package:lakasir/utils/colors.dart';

class SelectInputWidget extends StatefulWidget {
  const SelectInputWidget({
    super.key,
    required this.options,
    required this.controller,
    this.label = "",
    this.hintText = "",
    this.mandatory = false,
    this.errorText = "",
  });
  final List<Option> options;
  final String label;
  final String hintText;
  final bool mandatory;
  final String errorText;
  final SelectInputWidgetController controller;

  @override
  State<SelectInputWidget> createState() => _SelectInputWidgetState();
}

class _SelectInputWidgetState extends State<SelectInputWidget> {
  String? selectedOption; // Initial selected option

  @override
  void initState() {
    super.initState();
    selectedOption = widget.controller.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: secondary,
                ),
                children: [
                  TextSpan(text: widget.label),
                  if (widget.mandatory)
                    const TextSpan(
                      text: "*",
                      style: TextStyle(color: error),
                    ),
                ],
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.errorText.isNotEmpty ? error : secondary,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          width: double.infinity,
          child: DropdownButton<String>(
            hint: Text(widget.hintText),
            value: selectedOption,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption = newValue;
                widget.controller.selectedOption = newValue;
              });
            },
            items: widget.options.map((Option option) {
              return DropdownMenuItem<String>(
                value: option.value,
                onTap: option.onTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(option.name),
                    if (option.icon != null) option.icon!,
                  ],
                ),
              );
            }).toList(),
            isExpanded: true,
            underline: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        if (widget.errorText.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 5, left: 10),
            child: Text(
              widget.errorText,
              style: const TextStyle(color: error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class Option {
  final String name;
  final String value;
  final void Function()? onTap;
  final Icon? icon;

  Option({required this.name, required this.value, this.onTap, this.icon});
}

class SelectInputWidgetController {
  String? selectedOption;
}
