import 'package:flutter/material.dart';
import '../widgets/scanner_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  DepartmentScreenState createState() => DepartmentScreenState();
  }

class DepartmentScreenState extends State<DepartmentScreen> {
  List<String> departmentNames = [];
  bool isDataFetched = false;
  String selectedDepartment = '';

 @override
  void initState() {
    super.initState();
    fetchDepartmentFromServer();
  }

  Future<void> fetchDepartmentFromServer() async {
    if (!isDataFetched) {
      try {
        final response = await http.get(Uri.parse('${AppConfig.apiUrl}/all-departments'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            departmentNames = data.map((entry) => entry['DepartmentName'].toString()).toList();
            isDataFetched = true;
          });
        } else {
          print('HTTP request failed with status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error during data fetching: $error');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DepartmentScannerWidget(
            onDepartmentCodeDetected: (departmentCode) {
              print(departmentCode);
            },
            overlayColor: Colors.black.withOpacity(0.3),
          ),
          Positioned(
            bottom: 100, 
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownSearch<String>(
                    items: departmentNames,
                    popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        showSelectedItems: true,
                        scrollbarProps: ScrollbarProps(
                          thickness: 7,
                          radius: Radius.circular(10),
                          thumbColor: Colors.blue,
                          mainAxisMargin: 10,
                          crossAxisMargin: 10,
                        ),
                        menuProps: MenuProps(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        )),
                    dropdownButtonProps: const DropdownButtonProps(
                      icon: Icon(Icons.arrow_drop_down_circle_outlined),
                      iconSize: 36,
                    ),
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Avdelning: ",
                          labelStyle: TextStyle(fontSize: 18),
                        ),
                        textAlign: TextAlign.center),
                    onChanged: (String? value) {
                      setState(() {
                        selectedDepartment = value!;
                      });
                    }),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    //
                  },
                  child: Text('Ok'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}