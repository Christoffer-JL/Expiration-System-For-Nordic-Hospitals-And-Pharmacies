import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class expandCard extends StatefulWidget {
  final String title;
  final String batchNumber;
  final Future<void> Function() onDelete;
  final String productCode;
  final String nordicNumber;

  expandCard({
    required this.title,
    required this.onDelete,
    required this.batchNumber,
    required this.productCode,
    required this.nordicNumber,
  });

  @override
  _DatabaseCardState createState() => _DatabaseCardState();
}

class _DatabaseCardState extends State<expandCard> {
  bool isExpanded = false;
  List<String> dataList = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Color.fromARGB(255, 8, 98, 116),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ListTile(
            leading: IconButton(
              icon: Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
            title: Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          if (isExpanded)
            Column(
              children: [
                Text(
                  'Batchnr: ${widget.batchNumber}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Varunr: ${widget.nordicNumber}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DepartmentName: ${widget.departmentName}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        // Call the onDelete function with the department ID or index
                        deleteDepartment(
                          widget.productCode,
                          widget.batchNumber,
                          widget.departmentName,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

Future<List<String>> getDepartments(
    String productCode, String batchNumber) async {
  final String baseUrl = 'http://localhost:3000'; // Replace with your API URL

  final Map<String, dynamic> requestData = {
    'ProductCode': productCode,
    'BatchNumber': batchNumber,
  };

  final Uri uri = Uri.parse(
      '$baseUrl/departments-containing-entry'); // Replace '1' with the actual DepartmentId

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final List<dynamic> departmentData = json.decode(response.body);
    final List<String> departmentNames = departmentData
        .map((entry) => entry['DepartmentName'] as String)
        .toList();
    return departmentNames;
  } else {
    throw Exception('Failed to load departments: ${response.statusCode}');
  }
}

Future<void> deleteDepartment(
    String productCode, String batchNumber, String departmentName) async {
  try {
    final String baseUrl = 'http://localhost:3000';

    final response = await http.post(
      '$baseUrl/remove-entry-from-single-department',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'ProductCode': productCode,
        'BatchNumber': batchNumber,
        'DepartmentName': departmentName,
      }),
    );

    if (response.statusCode == 200) {
      // Department was successfully deleted from the API
      // You can now update your UI to reflect the removal
    } else {
      throw Exception('Failed to delete department: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting department: $e');
    // Handle the error as needed, e.g., show an error message to the user
  }
}
