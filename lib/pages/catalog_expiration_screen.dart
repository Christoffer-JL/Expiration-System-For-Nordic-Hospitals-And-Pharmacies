import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_test_pca/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CatalogExpirationScreen extends StatefulWidget {
  const CatalogExpirationScreen({super.key});

  @override
  CatalogExpirationScreenState createState() => CatalogExpirationScreenState();
}

class CatalogExpirationScreenState extends State<CatalogExpirationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
  }

  Future<void> fetchDataFromServer() async {
    try {
      final response =
          await http.get(Uri.parse('${AppConfig.apiUrl}/expiration-entries'));
      final List<dynamic> data = json.decode(response.body);

      final List<Map<String, dynamic>> productsData = data.map((entry) {
        final articleName = entry['ArticleName'];
        final packaging = entry['Packaging'];
        final expiration = entry['ExpirationDate'];
        final nordicNumber = entry['NordicNumber'].toString();
        final batchNumber = entry['BatchNumber'];
        final departments = (entry['Departments'] as String).split(', ');

        final parsedExpiration = DateTime.parse(expiration).toLocal();
        final formattedExpiration =
            DateFormat('yyyy-MM-dd').format(parsedExpiration);

        final key = '$articleName, $packaging, $formattedExpiration';
        return {
          'key': key,
          'articleName': articleName,
          'packaging': packaging,
          'expiration': formattedExpiration,
          'nordicNumber': nordicNumber,
          'batchNumber': batchNumber,
          'departments': departments,
        };
      }).toList();

      if (response.statusCode == 200) {
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during data fetching: $error');
    }
  }
}
