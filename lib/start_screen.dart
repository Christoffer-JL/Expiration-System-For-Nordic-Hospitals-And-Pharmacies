import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'widgets/scanned_pop_up.dart';
import 'widgets/qr_scanner_overlay.dart';
import 'package:vibration/vibration.dart';

MobileScannerController cameraController = MobileScannerController();

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String pc = "";
  String serial = "";
  String exp = "";
  String batch = "";
  bool scanEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inloggad som: Hjärtavdelningen'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (scanEnabled) {
                final List<Barcode> barcodes = capture.barcodes;
                final barcode = barcodes.first;
                String qrCodeData = barcode.displayValue!;

                if (qrCodeData.substring(1, 3).compareTo("01") == 0) {
                  scanEnabled = false;
                  Uint8List data = barcode.rawBytes!;

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
                    pc =
                        "PC: ${qrCodeData.substring(pcStartIndex + 2, pcStartIndex + 16)}";
                    qrCodeData = qrCodeData.substring(0, pcStartIndex) +
                        qrCodeData.substring(pcStartIndex + 16);
                  }

                  // Find and extract SERIAL from the end of the string
                  final serialStartIndex = qrCodeData.length - delimiter;
                  if (serialStartIndex != -1) {
                    serial =
                        "SERIAL: ${qrCodeData.substring(serialStartIndex + 2)}";
                    qrCodeData = qrCodeData.substring(0, serialStartIndex);
                  }

                  // Find and extract EXP
                  final expStartIndex = qrCodeData.indexOf('17');
                  if (expStartIndex != -1) {
                    exp =
                        "EXP: ${qrCodeData.substring(expStartIndex + 2, expStartIndex + 8)}";
                    qrCodeData = qrCodeData.substring(0, expStartIndex) +
                        qrCodeData.substring(expStartIndex + 8);
                  }

                  // Whatever is left should be BATCH
                  batch =
                      "BATCH: ${qrCodeData.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').substring(2)}";

                  setState(() {
                    pc = pc;
                    exp = exp;
                    batch = batch;
                    serial = serial;
                  });

                  Vibration.vibrate(duration: 100);

                  debugPrint("Barcode found $pc");
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomPopup(
                        pc: pc,
                        exp: exp,
                        batch: batch,
                        serial: serial,
                        onPopupDismissed: () {
                          // Enable scanning after the popup is dismissed
                          setState(() {
                            scanEnabled = true;
                          });
                        },
                      );
                    },
                  );
                } else if (qrCodeData.length == 13) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text("Oops, du skannade en EAN-kod"),
                      );
                    },
                  );
                } else {
                  debugPrint(
                      "Handle me! ${barcode.displayValue!.substring(0, 1)} length: ${qrCodeData.length}");
                }
              }
            },
          ),
          QRScannerOverlay(
            overlayColour: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
