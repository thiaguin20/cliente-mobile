import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.helperText,
    this.prefixIcon,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? helperText;
  final IconData? prefixIcon;
  final int maxLines;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
      ),
    );
  }
}
