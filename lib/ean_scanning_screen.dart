import 'package:flutter/material.dart';

class EanScanningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EAN Scanning Screen'),
      ),
      body: Center(
        child: Text('Scan EAN Code Here'),
      ),
    );
  }
}
