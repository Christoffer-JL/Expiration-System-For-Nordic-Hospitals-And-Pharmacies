import 'package:flutter/material.dart';
import 'widgets/pop_up.dart'; // Import your PopUp widget
import 'widgets/pop_up_insert.dart';

class CatalogExpirationScreen extends StatelessWidget {
  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUp(
          title: 'Popup Title',
          content: 'Popup Content',
          buttonText1: 'Cancel',
          buttonText2: 'OK',
          onPressed: () {
            // Handle OK button press logic here if needed
            Navigator.of(context).pop(); // Close the popup
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Center(
            child: Text(
              'Expiration screen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}