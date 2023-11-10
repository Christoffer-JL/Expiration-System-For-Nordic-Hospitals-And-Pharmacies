import 'package:flutter/material.dart';
import 'package:flutter_local_test_pca/config/config.dart';
import 'package:flutter_local_test_pca/widgets/expand_card.dart';
import 'package:flutter_local_test_pca/widgets/custom_image_button.dart';
import 'package:flutter_local_test_pca/widgets/pop_up.dart';
import '../widgets/pop_up_insert.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CatalogStartScreen extends StatefulWidget {
  const CatalogStartScreen({super.key});

  @override
  CatalogStartScreenState createState() => CatalogStartScreenState();
}

class CatalogStartScreenState extends State<CatalogStartScreen> {
  List<Map<dynamic, dynamic>> productDataList = [];
  List<Map<dynamic, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
  }

  Future<void> fetchDataFromServer() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.apiUrl}/entries-with-departments'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<Map<String, dynamic>> productsData = data.map((entry) {
          final productCode = entry['ProductCode'].toString();
          final articleName = entry['ArticleName'];
          final packaging = entry['Packaging'];
          final expiration = entry['ExpirationDate'];
          final nordicNumber = entry['NordicNumber'].toString();
          final batchNumber = entry['BatchNumber'];
          final departments = (entry['Departments'] as String).split(', ');

          final parsedExpiration = DateTime.parse(expiration)
              .toLocal(); // Parse and convert to local time zone
          final formattedExpiration =
              DateFormat('yyyy-MM-dd').format(parsedExpiration);

          final key = '$articleName, $packaging, $formattedExpiration';
          return {
            'key': key,
            'productCode': productCode,
            'articleName': articleName,
            'packaging': packaging,
            'expiration': formattedExpiration,
            'nordicNumber': nordicNumber,
            'batchNumber': batchNumber,
            'departments': departments,
          };
        }).toList();
        //print(productsData);
        setState(() {
          productDataList = productsData;
        });
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during data fetching: $error');
    }
  }

  void updateProductDataList(List<Map<dynamic, dynamic>> searchResults) {
    if (searchResults.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUp(
            title: 'Inga läkemedel kunde hittas',
            content: 'Vänligen kontrollera filtreringsuppgifterna',
            buttonText1: 'OK',
            buttonText2: '',
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
    setState(() {
      this.searchResults = searchResults;
      print(this.searchResults);
    });
  }

  Future<void> deleteProduct(int index, List<String> departments,
      String expiration, String productCode) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppConfig.apiUrl}/delete-medication'),
        body: json.encode({
          'DepartmentName': departments.first,
          'ExpirationDate': expiration,
          'ProductCode': productCode,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Medication deleted successfully');
        await fetchDataFromServer();
        setState(() {
          searchResults = [];
        });
      } else if (response.statusCode == 500) {
        // Error deleting medication
        print('Error deleting medication: ${response.body}');
      } else {
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during medication deletion: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(247, 247, 220, 87),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CustomImageButton(
                    imagePath: 'assets/clipboard.png',
                    onPressed: () {
                      Navigator.pushNamed(context, '/catalog_expiration');
                    },
                  ),
                  const SizedBox(width: 15),
                  CustomImageButton(
                    imagePath: 'assets/filter.png',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PopUpInsert(onSearch: updateProductDataList);
                          });
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: ListView.builder(
              itemCount: searchResults.isNotEmpty
                  ? searchResults.length
                  : productDataList.length,
              itemBuilder: (context, index) {
                return ExpandCard(
                    title:
                        '${searchResults.isNotEmpty ? searchResults[index]['articleName'] : productDataList[index]['articleName']}, ${searchResults.isNotEmpty ? searchResults[index]['packaging'] : productDataList[index]['packaging']}, ${searchResults.isNotEmpty ? searchResults[index]['expiration'] : productDataList[index]['expiration']}',
                    nordicNumber: searchResults.isNotEmpty
                        ? searchResults[index]['nordicNumber']
                        : productDataList[index]['nordicNumber'],
                    departments: searchResults.isNotEmpty
                        ? searchResults[index]['departments']
                        : productDataList[index]['departments'],
                    batchNumber: searchResults.isNotEmpty
                        ? (searchResults[index]['batchNumber'] != null
                            ? searchResults[index]['batchNumber'].toString()
                            : 'N/A')
                        : (productDataList[index]['batchNumber'] != null
                            ? productDataList[index]['batchNumber'].toString()
                            : 'N/A'),
                    onDelete: () => deleteProduct(
                          index,
                          productDataList[index]['departments'],
                          productDataList[index]['expiration'],
                          productDataList[index]['productCode'].toString(),
                        ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
