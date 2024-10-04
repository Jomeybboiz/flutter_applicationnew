import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextStyle? hintTextStyle; // Optional hint text style parameter
  final Color? fillColor; // New parameter for fill color

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.hintTextStyle, // Accept hint text style
    this.fillColor, // Accept fill color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true, // Enable filling
          fillColor:
              fillColor ?? Colors.white, // Use fillColor or default to white
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          hintText: hintText,
          hintStyle: hintTextStyle ??
              TextStyle(
                color: Theme.of(context).colorScheme.primary, // Default color
              ), // Use custom hint text style if provided, otherwise fallback to default
        ),
      ),
    );
  }
}
