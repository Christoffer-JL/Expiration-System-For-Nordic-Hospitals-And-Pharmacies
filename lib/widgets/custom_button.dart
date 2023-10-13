import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double fontSize;
  final Color customBlack = Color.fromRGBO(0, 0, 0, 0.5); // Own custom color for the button.

  CustomButton({
    required this.text,
    required this.onPressed,
    required this.color,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Adjust the value as needed
        ),
        side: BorderSide(color: customBlack, width: 2), // Set the border color and width
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize,
        ),
      ),
    );
  }
}


