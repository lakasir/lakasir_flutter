import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lakasir/widgets/text_field.dart';

class MyDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final String? errorText;

  const MyDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.controller,
    this.label,
    this.hintText,
    this.errorText,
  });

  @override
  State<StatefulWidget> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    setState(() {
      widget.controller.text = DateFormat("yyyy-MM-dd").format(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      controller: widget.controller,
      label: widget.label,
      hintText: widget.hintText,
      onTap: () => _selectDate(context),
      readOnly: true,
      errorText: widget.errorText,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text = DateFormat("yyyy-MM-dd").format(picked);
      });
    }
  }
}
