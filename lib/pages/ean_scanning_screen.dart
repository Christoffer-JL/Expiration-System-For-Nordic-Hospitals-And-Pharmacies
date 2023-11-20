import 'package:flutter/material.dart';
import 'package:flutter_local_test_pca/widgets/pop_up.dart';
import '../widgets/scanner_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class EanScanningScreen extends StatefulWidget {
  const EanScanningScreen({super.key});

  @override
  EanScanningScreenState createState() => EanScanningScreenState();
}

class EanScanningScreenState extends State<EanScanningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          EanscannerWidget(
            overlayColor: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
