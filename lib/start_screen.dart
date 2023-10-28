import 'package:flutter/material.dart';
import 'widgets/custom_button.dart'; // Import your custom button widget

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF98FFAE),
      appBar: AppBar(
        title: const Text('Start Screen'),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 216, // Set the width as desired
                      height: 76, // Set the height as desired
                      child: CustomButton(
                        text: 'Registrera',
                        onPressed: () {
                          Navigator.pushNamed(context, '/qr_scan');
                        },
                        color: const Color(0xFF73C9DF),
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/scanner.png',
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 216, // Set the width as desired
                      height: 76, // Set the height as desired
                      child: CustomButton(
                        text: 'Katalog',
                        onPressed: () {
                          Navigator.pushNamed(context, '/catalog_start');
                        },
                        color: const Color(0xFFFDDD41),
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/catalog.png',
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
