import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final bool usingTimePicker;
  final bool mandatory;
  const MyDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.controller,
    this.mandatory = false,
    this.usingTimePicker = false,
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
    if (widget.usingTimePicker) {
      widget.controller.text =
          DateFormat("yyyy-MM-dd HH:mm:ss").format(_selectedDate).toString();
    } else {
      widget.controller.text =
          DateFormat("yyyy-MM-dd").format(_selectedDate).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      controller: widget.controller,
      mandatory: widget.mandatory,
      // readOnly: true,
      label: widget.label,
      hintText: widget.hintText,
      onTap: () => widget.usingTimePicker ? _selectDateTime() : _selectDate(),
      errorText: widget.errorText,
    );
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          widget.controller.text = DateFormat("yyyy-MM-dd HH:mm:ss")
              .format(_selectedDate)
              .toString();
        });
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
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
