import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../colors.dart';
class InputTextFieldSeller extends StatelessWidget {
  const InputTextFieldSeller({
    super.key,
    required this.controller,
    required this.title,
    required this.textTheme,
    this.suffixIcon
  });

  final TextEditingController controller;
  final String title;
  final TextTheme textTheme;
  final Widget? suffixIcon;

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
      ),

    );
  }
}