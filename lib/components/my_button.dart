import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? buttonColor; // Add buttonColor parameter
  final Color? textColor; // Add textColor parameter

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.buttonColor, // Accept buttonColor
    this.textColor, // Accept textColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: buttonColor ??
              Theme.of(context)
                  .colorScheme
                  .secondary, // Use provided buttonColor or fallback
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor ??
                  Theme.of(context)
                      .colorScheme
                      .inversePrimary, // Use provided textColor or fallback
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
