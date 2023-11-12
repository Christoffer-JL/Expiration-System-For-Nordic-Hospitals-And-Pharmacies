import 'package:flutter/material.dart';
import 'package:flutter_local_test_pca/widgets/pop_up.dart';
import 'scanner_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';
import 'dart:typed_data';
import '../pages/ean_scanning_screen.dart';
import '../config/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class QRScannerWidget extends StatefulWidget {
  final String selectedDepartment;
  final Color overlayColor;

  QRScannerWidget({
    required this.selectedDepartment,
    this.overlayColor = Colors.white,
  });
  @override
  _scannerWidgetState createState() => _scannerWidgetState();
}

class _scannerWidgetState extends State<QRScannerWidget> {
  late MobileScannerController cameraController;
  String pc = "";
  String serial = "";
  String exp = "";
  String batch = "";
  String selectedDepartment = "";
  bool scanEnabled = true;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<bool> insertDataToDatabase(String pc, String exp, String batch,
      String serial, String selectedDepartment) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/insert-entry-in-department'),
        body: json.encode({
          "DepartmentName": selectedDepartment,
          "ProductCode": pc,
          "BatchNumber": batch,
          "ExpirationDate": exp,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 201) {
        // Entry inserted successfully
        return true;
      } else {
        // Failed to insert entry
        print("Failed to insert entry. Status code: ${response.statusCode}");
        return false;
      }
    } catch (error) {
      print("Error during HTTP request: $error");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
        actions: [
          TorchAndCameraSwitchButton(cameraController: cameraController),
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
                    selectedDepartment = widget.selectedDepartment;
                  });

                  Vibration.vibrate(duration: 100);

                  debugPrint("Barcode found $pc");

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopUp(
                        title: "vill du registrera denna vara?",
                        content: ' $pc \n $exp \n $batch \n $serial',
                        buttonText1: '',
                        buttonText2: 'OK',
                        onPressed: () async {
                          bool result = await insertDataToDatabase(
                              pc, exp, batch, serial, selectedDepartment);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PopUp(
                                title: result ? "Lyckas" : "Misslyckas",
                                content: result
                                    ? 'Lyckad vararegistrering'
                                    : 'Det gick inte att registrera posten, försök igen',
                                buttonText1: '',
                                buttonText2: 'OK',
                                onPressed: () {
                                  print('okej');
                                  setState(() {
                                    scanEnabled = true;
                                    pc = "";
                                    exp = "";
                                    batch = "";
                                    serial = "";
                                  });
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                } else if (qrCodeData.length == 13) {
                  setState(() {
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopUp(
                        title: "Det är en EAN-kod",
                        content: 'Vill du skanna en EAN-kod istället?',
                        buttonText1: 'Nej',
                        buttonText2: 'Ja',
                        onPressed: () {
                          Navigator.pushNamed(context, '/ean_scan');
                        },
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
          ScannerOverlay(
            overlayColor: widget.overlayColor,
          ),
        ],
      ),
    );
  }
}

class DepartmentScannerWidget extends StatefulWidget {
  final Function(String) onDepartmentCodeDetected;
  final Color overlayColor;

  DepartmentScannerWidget({
    required this.onDepartmentCodeDetected,
    this.overlayColor = Colors.white,
  });
  @override
  _departmentScannerWidgetState createState() =>
      _departmentScannerWidgetState();
}

class _departmentScannerWidgetState extends State<DepartmentScannerWidget> {
  late MobileScannerController cameraController;
  String departmentCode = "";
  bool scanEnabled = true;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    cameraController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Department Code Scanner'),
        actions: [
          TorchAndCameraSwitchButton(cameraController: cameraController),
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
                String departmentCode = barcode.displayValue!;

                List<String> parts = departmentCode.split("|");

                if (parts.length >= 3) {
                  String validInfo = parts[2].trim();
                  setState(() {
                    departmentCode = validInfo;
                  });
                  Vibration.vibrate(duration: 100);
                  print(validInfo);
                } else {
                  print("invalid department code");
                  setState(() {
                    scanEnabled=false;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PopUp(
                          title: "Felaktig avdelningskod",
                          content: 'Försök igen',
                          buttonText1: '',
                          buttonText2: 'OK',
                          onPressed: () {
                            setState(() {
                              scanEnabled = true;
                              departmentCode = "";
                            });
                          },
                        );
                      });
                }
                widget.onDepartmentCodeDetected(departmentCode);
              }
            },
          ),
          ScannerOverlay(
            overlayColor: widget.overlayColor,
            scanAreaHeight: 100,
            scanAreaWidth: 400,
          ),
        ],
      ),
    );
  }
}

class EanscannerWidget extends StatefulWidget {
  final Color overlayColor;

  EanscannerWidget({
    this.overlayColor = Colors.white,
  });
  @override
  _eanScannerWidgetState createState() => _eanScannerWidgetState();
}

class _eanScannerWidgetState extends State<EanscannerWidget> {
  late MobileScannerController cameraController;
  String eanCode = "";
  bool scanEnabled = true;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    cameraController.dispose(); 
    super.dispose();
  }

  Future<bool> insertEntryAutomatic(
      String productCode, String batchNumber, String expirationDate) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/insert-entry-in-department'),
        body: json.encode({
          'ProductCode': productCode,
          'BatchNumber': batchNumber,
          'ExpirationDate': expirationDate,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 400) {
        return false;
      } else {
        return false;
      }
    } catch (error) {
      print('Error during HTTP request: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ean Code Scanner'),
        actions: [
          TorchAndCameraSwitchButton(cameraController: cameraController),
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
                String eanCode = barcode.displayValue!;

                if (eanCode.length == 13) {
                  setState(() {
                    eanCode = eanCode;
                  });
                  Vibration.vibrate(duration: 100);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PopUp(
                          title: "Registrera med EAN-kod",
                          content: '$eanCode',
                          buttonText1: 'Nej',
                          buttonText2: 'Ja',
                          onPressed: () {},
                        );
                      });
                }
              } else {
                print("invalid ean code");
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopUp(
                        title: "Felaktig EAN-kod",
                        content: 'Försök igen',
                        buttonText1: '',
                        buttonText2: 'OK',
                        onPressed: () {
                          setState(() {
                            scanEnabled = true;
                            eanCode = "";
                          });
                        },
                      );
                    });
              }
            },
          ),
          ScannerOverlay(
            overlayColor: widget.overlayColor,
            scanAreaHeight: 100,
            scanAreaWidth: 400,
          ),
        ],
      ),
    );
  }
}

class TorchAndCameraSwitchButton extends StatelessWidget {
  final MobileScannerController cameraController;

  TorchAndCameraSwitchButton({required this.cameraController});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TorchButton(cameraController: cameraController),
        CameraSwitchButton(cameraController: cameraController),
      ],
    );
  }
}

class TorchButton extends StatelessWidget {
  final MobileScannerController cameraController;

  TorchButton({required this.cameraController});
  @override
  Widget build(BuildContext context) {
    return IconButton(
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
    );
  }
}

class CameraSwitchButton extends StatelessWidget {
  final MobileScannerController cameraController;

  CameraSwitchButton({required this.cameraController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
      onPressed: () {
        cameraController.switchCamera();
      },
    );
  }
}
