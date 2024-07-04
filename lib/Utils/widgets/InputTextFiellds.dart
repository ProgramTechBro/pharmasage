import 'package:flutter/material.dart';

import '../colors.dart';
class InputTextFieldSeller extends StatelessWidget {
  const InputTextFieldSeller({
    Key? key,
    required this.controller,
    required this.title,
    required this.textTheme,
    this.suffixIcon,
    this.validator, // Add validator parameter
  }) : super(key: key);

  final TextEditingController controller;
  final String title;
  final TextTheme textTheme;
  final Widget? suffixIcon;
  final String? Function(String?)? validator; // Validator function

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      cursorColor: black,
      decoration: InputDecoration(
        fillColor: grey,
        filled: true,
        hintText: title,
        hintStyle: textTheme.bodySmall!.copyWith(color: Colors.grey.shade600),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(35)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(35)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(35)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(35)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: suffixIcon,
        // Show error text based on validator
      ),
      validator: validator,
    );
  }
}
