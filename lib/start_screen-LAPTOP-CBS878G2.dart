import 'package:flutter/material.dart';
import 'widgets/custom_button.dart'; // Import your custom button widget

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF98FFAE),
      appBar: AppBar(
        title: Text('Start Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              width: 216,
              height: 76,
              child: CustomButton(
                text: 'Registrera',
                onPressed: () {
                  Navigator.pushNamed(context, '/qr_scan'); // Navigate to the QR scanning screen
                },
              color: Color(0xFF73C9DF),
              fontSize: 24,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 216,
              height: 76,
              child: CustomButton(
                text: 'Katalog',
                onPressed: () {
                  Navigator.pushNamed(context, '/catalog_start'); // Navigate to the QR scanning screen
                },
              color: Color(0xFFFDDD41),
              fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

