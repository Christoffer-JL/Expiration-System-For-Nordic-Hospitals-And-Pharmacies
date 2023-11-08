import 'package:flutter/material.dart';
import '../widgets/scanner_widget.dart';

class QrScanningScreen extends StatelessWidget {
  const QrScanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScannerWidget(
        onQRCodeDetected: (pc, serial, exp, batch) {
          print('$pc');
          print('$exp');
          print('$batch');
          print('$serial');
        },
        overlayColor: Colors.black.withOpacity(0.3),
      ),
    );
  }
}
