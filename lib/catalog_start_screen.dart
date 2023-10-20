import 'package:flutter/material.dart';
import 'package:flutter_local_test_pca/widgets/expand_card.dart';
import 'widgets/pop_up_insert.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class CatalogStartScreen extends StatefulWidget {

  @override
  _CatalogStartScreenState createState() => _CatalogStartScreenState();
}

class _CatalogStartScreenState extends State<CatalogStartScreen> {
  List<Map<String, dynamic>> productDataList = [];

@override
  void initState() {
    super.initState();
    fetchDataFromServer();
  }

  Future<void> fetchDataFromServer() async {
  try {
    final response = await http.get(Uri.parse('http://localhost:3000/all-entries'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      
       final List<Map<String, dynamic>> productsData = data.map((entry) {
        //final nordicNumber = entry['NordicNumber'];
        final articleName = entry['ArticleName'];
        final productCode = entry['ProductCode'].toString();
        final departmentName = entry['DepartmentName'];
        final date = entry['ExpirationDate'];

        
        final originalDateTime = DateTime.parse(date);
      
        final formattedDate = DateFormat('yyyy-MM-dd').format(originalDateTime);

        final key = '$formattedDate, $articleName';

        return {
          'key': key,
          'articleName': articleName,
          'productCode': productCode,
          'departmentName': departmentName,
          'expirationDate': formattedDate,
        };
      }).toList();
     // print(products);
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
Future<void> deleteProduct(int index, String departmentName) async {
    // example code: delete product from server
    setState(() {
      productDataList.removeAt(index);
    });

    // check if product is associated with other departments
    
    final isProductAssociatedWithOtherDepartments =
        productDataList.any((product) => product['departmentName'] == departmentName);

    // if not, delete product from server
    if (!isProductAssociatedWithOtherDepartments) {
      // example code: delete product from server
    }
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      body: Stack(
        children: [
           Align (
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
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
                    imagePath:
                        'assets/shin.jfif', // Provide the path to your image asset
                    onPressed: () {
                      Navigator.pushNamed(context, '/catalog_expiration');
                    },
                  ),
                  SizedBox(width: 15),
                  CustomImageButton(
                    imagePath:
                        'assets/pingu.jpg', // Provide the path to your image asset
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PopUpInsert();
                          }); // Show the popup when the button is pressed
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
              itemCount: productDataList.length,
              itemBuilder: (context, index) {
                return expandCard(
                  title: '${productDataList[index]['articleName']}, ${productDataList[index]['expirationDate']}',
                  departmentName: productDataList[index]['departmentName'],
                  productCode: productDataList[index]['productCode'],
                  onDelete: () => deleteProduct(index, productDataList[index]['departmentName']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  
}

class CustomImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  CustomImageButton({
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Image.asset(
        imagePath,
        width: 50, // Set the width of the image
        height: 50, // Set the height of the image
      ),
    );
  }
}

