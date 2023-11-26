import 'package:flutter/material.dart';

class PopUp extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText1;
  final String buttonText2;
  final VoidCallback onPressed;
  final VoidCallback onPressed1;

  const PopUp({
    required this.title,
    required this.content,
    required this.buttonText1,
    required this.buttonText2,
    required this.onPressed,
    required this.onPressed1,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onPressed1();
            Navigator.of(context).pop();
          },
          child: Text(buttonText1),
        ),
        TextButton(
          onPressed: () {
            onPressed();
            Navigator.of(context).pop();
          },
          child: Text(buttonText2),
        ),
      ],
    );
  }
}
