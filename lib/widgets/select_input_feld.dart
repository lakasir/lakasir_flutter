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
    this.errorText,
  });
  final List<Option> options;
  final String label;
  final String hintText;
  final bool mandatory;
  final String? errorText;
  final SelectInputWidgetController controller;

  @override
  State<SelectInputWidget> createState() => _SelectInputWidgetState();
}

class _SelectInputWidgetState extends State<SelectInputWidget> {
  String? selectedOption; // Initial selected option

  @override
  void initState() {
    super.initState();
    selectedOption = widget.controller.selectedOption == ''
        ? null
        : widget.controller.selectedOption;
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
        DropdownButtonFormField<String>(
          hint: Text(widget.hintText),
          value: selectedOption,
          validator: (value) {
            if (widget.mandatory && value == null) {
              return "Field ${widget.label} is required";
            }
            return null;
          },
          onChanged: (String? newValue) {
            setState(() {
              selectedOption = newValue;
              widget.controller.selectedOption = newValue;
              widget.controller.selectedLabel = widget.options
                  .firstWhere((element) => element.value == newValue)
                  .name;
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
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
            errorText: widget.errorText == "" ? null : widget.errorText,
            errorStyle: const TextStyle(color: error, fontSize: 12),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: secondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Border radius
              borderSide: const BorderSide(color: primary),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
  String? selectedLabel;
}
