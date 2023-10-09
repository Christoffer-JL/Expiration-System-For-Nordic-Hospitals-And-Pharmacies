import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_test_pca/start_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CustomMobileScanner extends StatelessWidget {
  final MobileScannerController controller;
  final Function(BarcodeCapture) onDetect;
  final Function(String pc, String exp, String batch, String serial)
      onDataUpdate;

  CustomMobileScanner({
    required this.controller,
    required this.onDetect,
    required this.onDataUpdate,
  });

  @override
  Widget build(BuildContext context) {
    String pc = "", exp = "", batch = "", serial = "";
    return MobileScanner(
      controller: cameraController,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        final Uint8List? image = capture.image;
        String qrCodeData = "";
        Uint8List data = Uint8List(0);
        for (final barcode in barcodes) {
          qrCodeData = barcode.displayValue!;
          data = barcode.rawBytes!;
        }

        int delimiter = 0;

        for (int i = data.length - 1; i >= 0; i--) {
          if (data[i] == 29) {
            break;
          } else {
            delimiter++;
          }
        }

        // Find and extract PC
        final pcStartIndex = qrCodeData.indexOf('01');
        if (pcStartIndex != -1) {
          pc = "PC: " +
              qrCodeData.substring(pcStartIndex + 2, pcStartIndex + 16);
          qrCodeData = qrCodeData.substring(0, pcStartIndex) +
              qrCodeData.substring(pcStartIndex + 16);
        }

        // Find and extract SERIAL from the end of the string
        final serialStartIndex = qrCodeData.length - delimiter;
        if (serialStartIndex != -1) {
          serial = "SERIAL: " + qrCodeData.substring(serialStartIndex + 2);
          qrCodeData = qrCodeData.substring(0, serialStartIndex);
        }

        // Find and extract EXP
        final expStartIndex = qrCodeData.indexOf('17');
        if (expStartIndex != -1) {
          exp = "EXP: " +
              qrCodeData.substring(expStartIndex + 2, expStartIndex + 8);
          qrCodeData = qrCodeData.substring(0, expStartIndex) +
              qrCodeData.substring(expStartIndex + 8);
        }

        // Whatever is left should be BATCH
        batch = "BATCH: " +
            qrCodeData.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').substring(2);

        pc = pc;
        exp = exp;
        batch = batch;
        serial = serial;

        debugPrint("$pc, $exp, $batch, $serial");
        onDataUpdate(pc, exp, batch, serial);
      },
    );
  }
}