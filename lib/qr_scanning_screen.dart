import 'package:flutter/material.dart';

class QrScanningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanning Screen'),
      ),
      body: Center(
        child: Text('Scan QR Code Here'),
      ),
    );
  }
}
