import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;

  const MyDrawerTile({
    Key? key,
    required this.text,
    required this.icon,
    required this.textColor,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor), // Icon for the drawer tile
      title: Text(
        text,
        style: TextStyle(
          color: textColor, // Set text color
          fontWeight: FontWeight.bold, // Make text bold
        ),
      ),
      onTap: onTap, // Handle tap event
    );
  }
}
