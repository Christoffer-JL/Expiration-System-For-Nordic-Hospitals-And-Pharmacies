import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
//  String department = '';

  TextEditingController productNameController = TextEditingController();
  TextEditingController productCodeController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();
  TextEditingController batchNumberController = TextEditingController();

  Future<void> _insertMedicine() async {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String selectedDepartment = args?['selectedDepartment'] ?? '';
    final String productCode = args?['productCode'] ?? '';
    final String url = '${AppConfig.apiUrl}/insert-entry-in-department';
    productCodeController.text = productCode;

    final Map<String, dynamic> data = {
      'DepartmentName': selectedDepartment,
      'ProductCode': productCodeController.text,
      'BatchNumber': batchNumberController.text,
      'ExpirationDate': expirationDateController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        // Successful insertion
        print('Data inserted successfully');
      } else if (response.statusCode == 200) {
        // Entry already exists
        print('Entry for the specified department and product already exists');
      } else {
        // Handle errors
        print('Error inserting data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or server errors
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String selectedDepartment = args?['selectedDepartment'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manuell inmatning'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Positioned(
                top: 20.0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: productCodeController,
                      decoration: InputDecoration(labelText: 'Product Code'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/ean_scan',
                        arguments: {'selectedDepartment': selectedDepartment},
                      );
                    },
                    icon: Icon(Icons.image),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: expirationDateController,
                decoration: InputDecoration(labelText: 'Expiration Date'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: batchNumberController,
                decoration: InputDecoration(labelText: 'Batch Number'),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    _insertMedicine();
                  },
                  child: Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
