import 'package:flutter/material.dart';
import 'widgets/custom_button.dart'; // Import your custom button widget

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to the Start Screen'),
            SizedBox(height: 20), // Add some spacing
            CustomButton(
              text: 'button example',
              onPressed: () {
                // Add your button click logic here
                Navigator.pushNamed(
                    context, '/qr_scan'); // Navigate to the QR scanning screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
