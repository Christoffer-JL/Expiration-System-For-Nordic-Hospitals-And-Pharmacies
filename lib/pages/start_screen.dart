import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 129, 247, 221),
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
                      width: 216,
                      height: 76,
                      child: CustomButton(
                        text: 'Registrera',
                        onPressed: () {
                          Navigator.pushNamed(context, '/department');
                        },
                        color: const Color(0xFF73C9DF),
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/qr-code-scan-icon-blue.png',
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
                      width: 216,
                      height: 76,
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
                      'assets/catalogue-icon-yellow.png',
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
