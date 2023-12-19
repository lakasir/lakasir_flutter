import 'package:flutter/material.dart';
import 'package:lakasir/utils/colors.dart';

typedef MyCallback = void Function(String);

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String hintText;
  final bool mandatory;
  final String errorText;
  final bool obscureText;
  final int? maxLines;
  final Widget? rightIcon;
  final Function(String)? onSubmitted;

  const MyTextField({
    super.key,
    this.label,
    this.mandatory = false,
    required this.controller,
    this.hintText = "",
    this.obscureText = false,
    this.errorText = "",
    this.maxLines = 1,
    this.rightIcon,
    this.onSubmitted,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool showPassword = false;
  bool securedText = false;
  @override
  void initState() {
    super.initState();
    securedText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
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
        TextField(
          maxLines: widget.maxLines,
          controller: widget.controller,
          obscureText: securedText,
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            suffixIcon: widget.obscureText
                ? InkWell(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                        securedText = !securedText;
                      });
                    },
                    child: Icon(
                      showPassword
                          ? Icons.remove_red_eye
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  )
                : widget.rightIcon,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 12.0,
            ), // Adjust the padding as needed
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
            errorText: widget.errorText == "" ? null : widget.errorText,
            errorStyle: const TextStyle(color: error, fontSize: 12),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Border radius
              borderSide: const BorderSide(color: error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Border radius
            ),
          ),
        )
      ],
    );
  }
}
