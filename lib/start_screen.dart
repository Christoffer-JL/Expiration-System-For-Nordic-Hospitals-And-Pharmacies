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
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
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
                      Navigator.pushNamed(context, '/qr_scan');
                    },
                    color: Color(0xFF73C9DF),
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 216,
                  height: 76,
                  child: CustomButton(
                    text: 'Katalog',
                    onPressed: () {
                      Navigator.pushNamed(context, '/catalog_start');
                    },
                    color: Color(0xFFFDDD41),
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 290, // Adjust the top position as needed
            left: 310, // Adjust the left position as needed
            child: Image.asset(
              'assets/scanner.png',
              width: 50,
              height: 50,
            ),
          ),
          Positioned(
            top: 390, // Adjust the top position as needed
            left: 310, // Adjust the left position as needed
            child: Image.asset(
              'assets/catalog.png',
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
