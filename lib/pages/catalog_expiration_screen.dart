import 'package:flutter/material.dart';
import 'package:flutter_local_test_pca/config/config.dart';
import 'package:flutter_local_test_pca/widgets/expand_card.dart';
import 'package:flutter_local_test_pca/widgets/custom_image_button.dart';
import 'package:flutter_local_test_pca/widgets/pop_up.dart';
import '../widgets/pop_up_insert.dart';
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
  List<Map<dynamic, dynamic>> searchResults = [];

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

          final parsedExpiration = DateTime.parse(expiration)
              .toLocal(); // Parse and convert to local time zone
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
        });
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during data fetching: $error');
    }
  }

  void updateProductDataList(List<Map<dynamic, dynamic>> searchResults) {
    print('Search Results: $searchResults');
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
              Navigator.pop(context);
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

      if (response.statusCode == 200) {
        print('Medication deleted successfully');
        setState(() {
          productDataList
              .removeAt(index); // Remove the item from the product list
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
            color:
                Color.fromARGB(247, 247, 220, 87), // Set background color here
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
              itemCount: productDataList.length,
              itemBuilder: (context, index) {
                return ExpandCardExpire(
                    title:
                        '${searchResults.isNotEmpty ? searchResults[index]['departments'] : productDataList[index]['departments']}',
                    articleName: searchResults.isNotEmpty
                        ? (searchResults[index]['articleName'] != null
                            ? searchResults[index]['articleName'].toString()
                            : 'N/A')
                        : (productDataList[index]['articleName'] != null
                            ? productDataList[index]['articleName'].toString()
                            : 'N/A'),
                    packaging: searchResults.isNotEmpty
                        ? (searchResults[index]['packaging'] != null
                            ? searchResults[index]['packaging'].toString()
                            : 'N/A')
                        : (productDataList[index]['packaging'] != null
                            ? productDataList[index]['packaging'].toString()
                            : 'N/A'),
                    expirationDate: searchResults.isNotEmpty
                        ? (searchResults[index]['expiration'] != null
                            ? searchResults[index]['expiration'].toString()
                            : 'N/A')
                        : (productDataList[index]['expiration'] != null
                            ? productDataList[index]['expiration'].toString()
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
