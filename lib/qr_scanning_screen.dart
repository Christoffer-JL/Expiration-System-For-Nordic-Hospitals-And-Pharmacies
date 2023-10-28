import 'package:flutter/material.dart';

class QrScanningScreen extends StatelessWidget {
  const QrScanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanning Screen'),
      ),
      body: const Center(
        child: Text('Scan QR Code Here'),
      ),
    );
  }
}
