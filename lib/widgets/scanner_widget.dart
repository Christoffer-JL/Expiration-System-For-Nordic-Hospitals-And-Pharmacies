import 'package:flutter/material.dart';
import 'package:flutter_local_test_pca/pages/start_screen.dart';
import 'package:flutter_local_test_pca/widgets/pop_up.dart';
import '../pages/department_screen.dart';
import '../pages/input_screen.dart';
import 'scanner_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';
import 'dart:typed_data';
import '../config/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QRScannerWidget extends StatefulWidget {
  final String selectedDepartment;
  final Color overlayColor;
  final MobileScannerController controller;

  QRScannerWidget({
    required this.controller,
    required this.selectedDepartment,
    this.overlayColor = Colors.white,
  });
  @override
  _scannerWidgetState createState() => _scannerWidgetState();
}

class _scannerWidgetState extends State<QRScannerWidget> {
  String pc = "";
  String NordicNumber = "";
  String serial = "";
  String exp = "";
  String batch = "";
  String selectedDepartment = "";
  bool scanEnabled = true;

  Future<bool> insertDataToDatabase(String pc, String exp, String batch,
      String serial, String selectedDepartment) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/insert-entry-in-department'),
        body: json.encode({
          "DepartmentName": selectedDepartment,
          "ProductCode": pc,
          "BatchNumber": batch,
          "ExpirationDate": convertStringToDate(exp),
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to insert entry. Status code: ${response.statusCode}");
        print(selectedDepartment);
        print(pc);
        print(batch);
        print(convertStringToDate(exp));
        return false;
      }
    } catch (error) {
      print("Error during HTTP request: $error");
      return false;
    }
  }

  Future<void> getNordicNumber(String productCode) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}/getNordicNumber/$productCode'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final nordicNumber = data['nordicNumber'] as int?;

        if (nordicNumber != null) {
          setState(() {
            NordicNumber = nordicNumber.toString();
          });
          print(NordicNumber);
        } else {
          print('Product not found or NordicNumber not available');
        }
      } else {
        print('Error: ${response.statusCode}');

        print('Calling getNordicNumber with productCode:$productCode');
      }
    } catch (error) {
      print('Error during HTTP request: $error');
    }
  }

  String convertStringToDate(String input) {
    if (input.length != 6) {
      return input;
    }

    String firstTwoDigits = input.substring(0, 2);
    String year;

    if (int.parse(firstTwoDigits) >= 21 && int.parse(firstTwoDigits) <= 99) {
      year = "20$firstTwoDigits";
    } else {
      year = "21$firstTwoDigits";
    }

    String month = input.substring(2, 4);
    String day = input.substring(4, 6);

    String formattedDate = "$year-$month-$day";

    return formattedDate;
  }

  Widget buildPopUpContent(
      bool result, BuildContext context, _scannerWidgetState state) {
    return PopUp(
      title: result ? "Lyckas" : "Misslyckas",
      content: result
          ? 'Lyckad vararegistrering'
          : 'Det gick inte att registrera posten, försök igen',
      buttonText1: '',
      buttonText2: 'OK',
      onPressed1: () {},
      onPressed: () {
        print('Ok');
        state.setState(() {
          state.scanEnabled = true;
          state.pc = "";
          state.exp = "";
          state.batch = "";
          state.serial = "";
          state.NordicNumber = "";
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('QR Code Scanner'),
          actions: [
            TorchAndCameraSwitchButton(cameraController: widget.controller),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              widget.controller.stop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DepartmentScreen()),
              );
            },
          )),
      body: Stack(
        children: [
          MobileScanner(
            controller: widget.controller,
            onDetect: (capture) async {
              if (scanEnabled) {
                final List<Barcode> barcodes = capture.barcodes;
                final barcode = barcodes.first;
                String qrCodeData = barcode.displayValue!;

                if (qrCodeData.substring(1, 3).compareTo("01") == 0) {
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
                    pc = qrCodeData.substring(
                        pcStartIndex + 2, pcStartIndex + 16);

                    await getNordicNumber(pc);

                    qrCodeData = qrCodeData.substring(0, pcStartIndex) +
                        qrCodeData.substring(pcStartIndex + 16);
                  }

                  int count = 0;

                  for (int i = 0; i < data.length; i++) {
                    if (data[i] == 29) {
                      count++;
                    }
                  }

                  if (count == 3) {
                    var expStartIndex = qrCodeData.length - delimiter;
                    if (expStartIndex != -1) {
                      exp = qrCodeData.substring(
                          expStartIndex + 2, expStartIndex + 8);
                      qrCodeData = qrCodeData.substring(0, expStartIndex) +
                          qrCodeData.substring(expStartIndex + 8);
                    }

                    delimiter = 0;

                    for (int i = data.length - 1; i >= 0; i--) {
                      if (data[i] == 29) {
                        break;
                      } else {
                        delimiter++;
                      }
                    }

                    final batchStartIndex = qrCodeData.length - delimiter;
                    if (batchStartIndex != -1) {
                      batch = qrCodeData.substring(batchStartIndex + 3);

                      qrCodeData = qrCodeData.substring(0, batchStartIndex);
                    }

                    serial = qrCodeData
                        .replaceAll(RegExp(r'[^A-Za-z0-9]'), '')
                        .substring(2);
                  } else {
                    final serialStartIndex = qrCodeData.length - delimiter;
                    String serialCheck = "";
                    if (serialStartIndex != -1) {
                      serial = qrCodeData.substring(serialStartIndex + 2);
                      serialCheck = qrCodeData.substring(serialStartIndex + 2);

                      qrCodeData = qrCodeData.substring(0, serialStartIndex);
                    }

                    var expStartIndex = qrCodeData.indexOf('17');
                    if (expStartIndex != -1) {
                      exp = qrCodeData.substring(
                          expStartIndex + 2, expStartIndex + 8);
                      qrCodeData = qrCodeData.substring(0, expStartIndex) +
                          qrCodeData.substring(expStartIndex + 8);
                    }

                    // Delimiter can sometimes be misplaced. IF this is the case, EXP must be extracted from SERIAL
                    if (exp.isEmpty) {
                      exp = serialCheck.substring(0, 6);
                      serial = serialCheck.substring(8);
                    }

                    // Whatever is left should be BATCH
                    batch = qrCodeData
                        .replaceAll(RegExp(r'[^A-Za-z0-9]'), '')
                        .substring(2);
                  }
                  setState(() {
                    pc = pc.replaceAll(String.fromCharCode(29), '');
                    exp = exp.replaceAll(String.fromCharCode(29), '');
                    batch = batch.replaceAll(String.fromCharCode(29), '');
                    serial = serial.replaceAll(String.fromCharCode(29), '');
                    selectedDepartment = widget.selectedDepartment;
                    scanEnabled = false;
                  });

                  Vibration.vibrate(duration: 100);

                  debugPrint("Barcode found $pc");

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopUp(
                        title: "vill du registrera denna vara?",
                        content:
                            ' PC: $pc \n Exp: $exp \n Batch: $batch \n Serial: $serial \n Varunummer: $NordicNumber',
                        buttonText1: 'Avbryt',
                        buttonText2: 'Ja',
                        onPressed1: () {
                          setState(() {
                            scanEnabled = true;
                            pc = "";
                            exp = "";
                            batch = "";
                            serial = "";
                            NordicNumber = "";
                          });
                        },
                        onPressed: () async {
                          Navigator.maybePop(context);
                          bool result = await insertDataToDatabase(
                              pc, exp, batch, serial, selectedDepartment);
                          BuildContext dialogContext = context;
                          showDialog(
                            context: dialogContext,
                            builder: (BuildContext context) {
                              return buildPopUpContent(result, context, this);
                            },
                          );
                        },
                      );
                    },
                  );
                } else if (qrCodeData.length == 13) {
                  setState(() {
                    scanEnabled = false;
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopUp(
                        title: "Det är en EAN-kod",
                        content: 'Vill du göra manuell inmatning istället?',
                        buttonText1: 'Nej',
                        buttonText2: 'Ja',
                        onPressed1: () {
                          setState(() {
                            scanEnabled = true;
                          });
                        },
                        onPressed: () {
                          widget.controller.stop();
                          Navigator.pushNamed(context, '/input', arguments: {
                            'selectedDepartment': selectedDepartment
                          });
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
  final Color overlayColor;
  final MobileScannerController controller;

  DepartmentScannerWidget({
    this.overlayColor = Colors.white,
    required this.controller,
  });

  @override
  _departmentScannerWidgetState createState() =>
      _departmentScannerWidgetState();
}

class _departmentScannerWidgetState extends State<DepartmentScannerWidget> {
  String departmentCode = "";
  bool scanEnabled = true;
  bool isDataFetched = false;
  List<String> departmentNames = [];

  Future<void> fetchDepartmentFromServer() async {
    if (!isDataFetched) {
      try {
        final response =
            await http.get(Uri.parse('${AppConfig.apiUrl}/all-departments'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            departmentNames = data
                .map((entry) => entry['DepartmentName'].toString())
                .toList();
            isDataFetched = true;
          });
        } else {
          print('HTTP request failed with status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error during data fetching: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Department Code Scanner'),
          actions: [
            TorchAndCameraSwitchButton(cameraController: widget.controller),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              widget.controller.stop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => StartScreen()),
              );
            },
          )),
      body: Stack(
        children: [
          MobileScanner(
            controller: widget.controller,
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
                  Vibration.vibrate(duration: 300);
                  print(validInfo);
                  fetchDepartmentFromServer();
                  bool isMatch = departmentNames.contains(departmentCode);
                  if (isMatch) {
                    widget.controller.stop();
                    Navigator.pushNamed(
                      context,
                      '/qr_scan',
                      arguments: {'selectedDepartment': departmentCode},
                    );
                  }
                  ;
                } else {
                  print("invalid department code");
                  setState(() {
                    scanEnabled = false;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PopUp(
                          title: "Felaktig avdelningskod",
                          content: 'Försök igen',
                          buttonText1: '',
                          buttonText2: 'OK',
                          onPressed1: () {},
                          onPressed: () {
                            setState(() {
                              scanEnabled = true;
                              departmentCode = "";
                            });
                          },
                        );
                      });
                }
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
      String pc, String exp, String batch, String selectedDepartment) async {
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
        return true;
      } else {
        print("Failed to insert entry. Status code: ${response.statusCode}");
        return false;
      }
    } catch (error) {
      print("Error during HTTP request: $error");
      return false;
    }
  }

  void startScanner() {
    setState(() {
      scanEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String selectedDepartment = args?['selectedDepartment'] ?? '';

    print('Selected Department in EanscannerWidget: $selectedDepartment');

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
                  eanCode = '0$eanCode';
                  setState(() {
                    eanCode = eanCode;
                  });
                  Vibration.vibrate(duration: 100);

                  setState(() {
                    scanEnabled = false;
                  });
                  String productCode = eanCode;
                  print(productCode);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopUp(
                        title: "För över EAN-kod?",
                        content: '$eanCode',
                        buttonText1: 'Nej',
                        buttonText2: 'Ja',
                        onPressed1: () {
                          scanEnabled = true;
                        },
                        onPressed: () async {
                          print('Ja pressed');
                          print('Product Code: $productCode');
                          Navigator.of(context).pop();

                          await Future.delayed(Duration(milliseconds: 100));

                          startScanner();

                          Navigator.popUntil(context,
                              (route) => !(route.settings.name == '/input'));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InputScreen(),
                              settings: RouteSettings(
                                arguments: {
                                  'productCode': productCode,
                                  'selectedDepartment': selectedDepartment,
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
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
                        onPressed1: () {},
                        onPressed: () {
                          setState(() {
                            scanEnabled = true;
                            eanCode = "";
                          });
                        },
                      );
                    },
                  );
                }
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
