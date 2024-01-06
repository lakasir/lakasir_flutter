import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lakasir/utils/colors.dart';

typedef MyCallback = void Function(String);
typedef ValidatorCallback = String? Function(String?);

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? info;
  final String? hintText;
  final bool mandatory;
  final String? errorText;
  final String prefixText;
  final bool obscureText;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final Widget? rightIcon;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function(PointerDownEvent)? onTapOutside;
  final ValidatorCallback? validator;
  final bool autofocus;
  final bool readOnly;
  final Function()? onTap;

  const MyTextField({
    super.key,
    this.label,
    this.info,
    this.mandatory = false,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.prefixText = "",
    this.errorText = "",
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.rightIcon,
    this.onSubmitted,
    this.onChanged,
    this.onTapOutside,
    this.autofocus = false,
    this.validator,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool showPassword = false;
  bool securedText = false;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    securedText = widget.obscureText;
    if (widget.autofocus) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null || widget.info != null)
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  RichText(
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
                if (widget.info != null)
                  Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: const Duration(seconds: 5),
                    message: widget.info!,
                    child: const Icon(
                      Icons.info_outline,
                      color: grey,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        TextFormField(
          focusNode: _focusNode,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))]
          textCapitalization: widget.textCapitalization!,
          onTapOutside: (value) {
            widget.onTapOutside != null ? widget.onTapOutside!(value) : null;
            _focusNode.unfocus();
          },
          maxLines: widget.maxLines,
          controller: widget.controller,
          obscureText: securedText,
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            if (widget.mandatory && value!.isEmpty) {
              return "The ${widget.label} field is required";
            }
            return null;
          },
          onFieldSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged,
          // onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            prefixText: widget.prefixText,
            prefixStyle: const TextStyle(color: secondary),
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
