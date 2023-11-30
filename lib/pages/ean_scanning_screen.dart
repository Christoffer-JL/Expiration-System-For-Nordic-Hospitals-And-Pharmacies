import 'package:flutter/material.dart';
import '../widgets/scanner_widget.dart';

class EanScanningScreen extends StatefulWidget {
  const EanScanningScreen({super.key});

  @override
  EanScanningScreenState createState() => EanScanningScreenState();
}

class EanScanningScreenState extends State<EanScanningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          EanscannerWidget(
            overlayColor: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
