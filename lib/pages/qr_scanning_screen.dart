import 'package:flutter/material.dart';
import '../widgets/scanner_widget.dart';

class QrScanningScreen extends StatelessWidget {
  const QrScanningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String selectedDepartment = args?['selectedDepartment'] ?? '';

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // QRScannerWidget，放置在底层
          QRScannerWidget(
            selectedDepartment: selectedDepartment,
            overlayColor: Colors.black.withOpacity(0.3),
          ),

          // 贴纸效果，放置在上层
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
                'Inloggad som : $selectedDepartment',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),

          // 放置在屏幕底部的按钮
          Positioned(
            bottom: 50.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/input',
                    arguments: {'selectedDepartment': selectedDepartment},
                  );
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
