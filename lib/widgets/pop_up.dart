import 'package:flutter/material.dart';

class PopUp extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText1;
  final String buttonText2;
  final VoidCallback onPressed;

  const PopUp({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText1,
    required this.buttonText2,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(buttonText1),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onPressed();
          },
          child: Text(buttonText2),
        ),
      ],
    );
  }
}
