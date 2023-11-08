import 'package:flutter/material.dart';
import '../widgets/scanner_widget.dart';
import '../widgets/scanner_overlay.dart';

class QrScanningScreen extends StatelessWidget {
  const QrScanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScannerWidget(
        onQRCodeDetected: (pc, serial, exp, batch) {
          print('PC: $pc');
          print('EXP: $exp');
          print('BATCH: $batch');
          print('SERIAL: $serial');
        },
        overlayColor: Colors.black.withOpacity(0.3),
      ),
    );
  }
}
