import 'package:flutter/material.dart';
import 'start_screen.dart';
import 'department_screen.dart';
import 'qr_scanning_screen.dart';
import 'input_screen.dart';
import 'catalog_start_screen.dart';
import 'ean_scanning_screen.dart';
import 'catalog_expiration_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PharmAware',
      initialRoute: '/',
      routes: {
        '/': (context) => StartScreen(),
        '/department': (context) => DepartmentScreen(),
        '/qr_scan': (context) => QrScanningScreen(),
        '/input': (context) => InputScreen(),
        '/catalog_start': (context) => CatalogStartScreen(),
        '/ean_scan': (context) => EanScanningScreen(),
        '/catalog_expiration': (context) => CatalogExpirationScreen(),
      },
    );
  }
}
