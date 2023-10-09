import 'package:flutter/material.dart';

class CustomPopup extends StatelessWidget {
  final String pc;
  final String exp;
  final String batch;
  final String serial;
  final Function onPopupDismissed;

  CustomPopup({
    required this.pc,
    required this.exp,
    required this.batch,
    required this.serial,
    required this.onPopupDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          "Produkt skannades, vill du registrera denna vara?"), // Set your title here
      content: Container(
        height: 200, // Set the desired height here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pc),
            Text(exp),
            Text(batch),
            Text(serial),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the popup when OK is pressed
            onPopupDismissed();
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
