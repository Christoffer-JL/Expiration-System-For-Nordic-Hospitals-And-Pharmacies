import 'package:flutter/material.dart';
import 'widgets/pop_up.dart'; // Import your PopUp widget

class CatalogStartScreen extends StatelessWidget {
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
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CustomImageButton(
                    imagePath: 'assets/pingu.jpg', // Provide the path to your image asset
                    onPressed: () {
                      Navigator.pushNamed(context, '/catalog_expiration');
                    },
                  ),
                  SizedBox(width: 15),
                  CustomImageButton(
                    imagePath: 'assets/pingu.jpg', // Provide the path to your image asset
                    onPressed: () {
                      _showPopup(context); // Show the popup when the button is pressed
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  CustomImageButton({
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Image.asset(
        imagePath,
        width: 50, // Set the width of the image
        height: 50, // Set the height of the image
      ),
    );
  }
}





