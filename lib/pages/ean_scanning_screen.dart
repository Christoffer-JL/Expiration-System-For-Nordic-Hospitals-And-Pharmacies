import 'package:flutter/material.dart';

class EanScanningScreen extends StatelessWidget {
  const EanScanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EAN Scanning Screen'),
      ),
      body: const Center(
        child: Text('Scan EAN Code Here'),
      ),
    );
  }
}
