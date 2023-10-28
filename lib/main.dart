import 'package:flutter/material.dart';
import 'start_screen.dart';
import 'department_screen.dart';
import 'qr_scanning_screen.dart';
import 'input_screen.dart';
import 'catalog_start_screen.dart';
import 'ean_scanning_screen.dart';
import 'catalog_expiration_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PharmAware',
      initialRoute: '/',
      routes: {
        '/': (context) => StartScreen(),
        '/department': (context) => const DepartmentScreen(),
        '/qr_scan': (context) => QrScanningScreen(),
        '/input': (context) => const InputScreen(),
        '/catalog_start': (context) => const CatalogStartScreen(),
        '/ean_scan': (context) => const EanScanningScreen(),
        '/catalog_expiration': (context) => const CatalogExpirationScreen(),
      },
    );
  }
}
