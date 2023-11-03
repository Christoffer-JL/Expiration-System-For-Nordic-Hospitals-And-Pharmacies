import 'package:flutter/material.dart';
import 'pages/start_screen.dart';
import 'pages/department_screen.dart';
import 'pages/qr_scanning_screen.dart';
import 'pages/input_screen.dart';
import 'pages/catalog_start_screen.dart';
import 'pages/ean_scanning_screen.dart';
import 'pages/catalog_expiration_screen.dart';

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
