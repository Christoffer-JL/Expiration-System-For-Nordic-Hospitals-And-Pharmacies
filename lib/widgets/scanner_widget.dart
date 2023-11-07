import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class scannerWidget extends StatefulWidget {
  const scannerWidget({Key? key}) : super(key: key);

  @override
  _QRCodeScannerWidgetState createState() => _QRCodeScannerWidgetState();
}

class _QRCodeScannerWidgetState extends State<scannerWidget> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              // Handle QR code detection here
              // You can extract and use the data from the scanned QR code
            },
          ),
          // Add any overlay or UI components as needed
        ],
      ),
    );
  }
}
