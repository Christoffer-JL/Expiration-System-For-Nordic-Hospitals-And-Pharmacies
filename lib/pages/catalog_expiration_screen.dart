import 'package:flutter/material.dart';
import 'package:flutter_local_test_pca/config/config.dart';
import 'package:flutter_local_test_pca/widgets/expand_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CatalogExpirationScreen extends StatefulWidget {
  const CatalogExpirationScreen({Key? key}) : super(key: key);

  @override
  CatalogExpirationScreenState createState() => CatalogExpirationScreenState();
}

class CatalogExpirationScreenState extends State<CatalogExpirationScreen> {
  List<Map<String, dynamic>> productDataList = [];
  Set<String> uniqueDepartments = <String>{};

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
  }

  Future<void> fetchDataFromServer() async {
    try {
      final response =
          await http.get(Uri.parse('${AppConfig.apiUrl}/expiration-entries'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<Map<String, dynamic>> productsData = data.map((entry) {
          final articleName = entry['ArticleName'] ?? 'N/A';
          final packaging = entry['Packaging'] ?? 'N/A';
          final expiration = entry['ExpirationDate'];
          final departments = entry['DepartmentName'] ?? '';
          final productCode = entry['ProductCode'].toString();

          final parsedExpiration = DateTime.parse(expiration).toLocal();
          final formattedExpiration =
              DateFormat('yyyy-MM-dd').format(parsedExpiration);

          final key = '$articleName, $packaging, $formattedExpiration';
          return {
            'key': key,
            'articleName': articleName,
            'packaging': packaging,
            'expiration': formattedExpiration,
            'departments': departments,
            'productCode': productCode,
          };
        }).toList();
        setState(() {
          productDataList = productsData;
          updateUniqueDepartments();
        });
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during data fetching: $error');
    }
  }

  void updateUniqueDepartments() {
    setState(() {
      uniqueDepartments = productDataList
          .map<String>((product) => product['departments'] as String)
          .toSet();
    });
  }

  Future<void> deleteProduct(
    int index,
    String departments,
    String expiration,
    String productCode,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppConfig.apiUrl}/delete-medication'),
        body: json.encode({
          'DepartmentName': departments,
          'ExpirationDate': expiration,
          'ProductCode': productCode,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (mounted) {
        if (response.statusCode == 200) {
          print('Medication deleted successfully');
          setState(() {
            final medicationIndex = productDataList.indexWhere((medication) =>
                medication['departments'] == departments &&
                medication['expiration'] == expiration &&
                medication['productCode'].toString() == productCode);

            if (medicationIndex != -1) {
              productDataList.removeAt(medicationIndex);
              updateUniqueDepartments();
            }
          });
        } else if (response.statusCode == 500) {
          print('Error deleting medication: ${response.body}');
        } else {
          print('Unexpected status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (mounted) {
        print('Error during medication deletion: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var product in productDataList) {
      String department = product['departments'];
      if (!groupedData.containsKey(department)) {
        groupedData[department] = [];
      }
      groupedData[department]!.add(product);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(247, 247, 220, 87),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: ListView.builder(
              itemCount: groupedData.length,
              itemBuilder: (context, index) {
                String department = groupedData.keys.elementAt(index);
                List<Map<String, dynamic>> medications =
                    groupedData[department]!;

                return ExpandCardExpire(
                  departments: department,
                  medications: medications,
                  onDelete: (int index, String department, String expiration,
                          String productCode) =>
                      deleteProduct(index, department, expiration, productCode),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
