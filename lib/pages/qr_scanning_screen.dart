import 'package:flutter/material.dart';
import 'package:flutter_local_test_pca/pages/input_screen.dart';
import '../widgets/scanner_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanningScreen extends StatefulWidget {
  const QrScanningScreen({Key? key}) : super(key: key);

  @override
  QrScanningScreenState createState() => QrScanningScreenState();
}

class QrScanningScreenState extends State<QrScanningScreen> {
  late MobileScannerController controller;

  @override
  void initState() {
    controller = MobileScannerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String selectedDepartment = args?['selectedDepartment'] ?? '';

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRScannerWidget(
            controller: controller,
            selectedDepartment: selectedDepartment,
            overlayColor: Colors.black.withOpacity(0.3),
          ),
          Positioned(
            top: 200.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                'Inloggad som: $selectedDepartment',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
          Positioned(
            bottom: 50.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  controller.stop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputScreen(),
                      settings: RouteSettings(
                        arguments: {'selectedDepartment': selectedDepartment},
                      ),
                    ),
                  ).then((value) {
                    controller.start();
                  });
                },
                child: Text('Registrera manuellt'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
