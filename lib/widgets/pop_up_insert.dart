import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../config/config.dart';

typedef SearchCallback = void Function(List<Map<dynamic, dynamic>>);

class PopUpInsert extends StatefulWidget {
  final SearchCallback onSearch;
  const PopUpInsert({Key? key, required this.onSearch}) : super(key: key);

  @override
  _PopUpInsert createState() => _PopUpInsert();
}

class _PopUpInsert extends State<PopUpInsert> {
  TextEditingController dateController = TextEditingController();
  TextEditingController batchController = TextEditingController();

  List<String> departmentNames = [];
  List<String> products = [];
  String selectedDepartment = '';
  String selectedProductName = '';
  bool isDataFetched = false;

  Future<void> fetchDepaarmentFromServer() async {
    try {
      final response =
          await http.get(Uri.parse('${AppConfig.apiUrl}/all-departments'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          departmentNames =
              data.map((entry) => entry['DepartmentName'].toString()).toList();
          isDataFetched = true;
        });
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during data fetching: $error');
    }
  }

  Future<void> fetchProductFromServer() async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.apiUrl}/entries'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        Set<String> uniqueEntries = Set<String>();

        setState(() {
          products = data
              .map((entry) {
                String entryString =
                    '${entry['NordicNumber']}, ${entry['ArticleName']}, ${entry['Packaging']}';

                if (!uniqueEntries.contains(entryString)) {
                  uniqueEntries.add(entryString);
                  return entryString;
                } else {
                  return null;
                }
              })
              .where((entry) => entry != null)
              .cast<String>()
              .toList();

          isDataFetched = true;
        });
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during data fetching: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDepaarmentFromServer();
    fetchProductFromServer();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2500),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dateController.text = picked.toString().substring(0, 10);
      });
    }
  }

  void searchButtonPressed() async {
    final queryParams = <String, String>{};

    if (selectedDepartment.isNotEmpty) {
      queryParams['DepartmentName'] = selectedDepartment;
    }

    if (batchController.text.isNotEmpty) {
      queryParams['BatchNr'] = batchController.text;
    }

    if (selectedProductName.isNotEmpty) {
      final parts = selectedProductName.split(', ');
      queryParams['NordicNumber'] = parts[0];
      queryParams['ProductName'] = parts[1];
      queryParams['Packaging'] = parts[2];
    }

    if (dateController.text.isNotEmpty) {
      queryParams['ExpirationDate'] = dateController.text;
    }

    final uri = Uri.http('${AppConfig.apiIp}:3000', '/entries', queryParams);
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<Map<String, dynamic>> searchData = data.map((entry) {
          final departmentList = (entry['Departments'] as String).split(', ');
          final matchingDepartments = <String>[];
          if (selectedDepartment.isNotEmpty) {
            matchingDepartments.addAll(departmentList
                .where((department) => department == selectedDepartment));
          }

          final articleName = entry['ArticleName'];
          final packaging = entry['Packaging'];
          final expiration = entry['ExpirationDate'];
          final nordicNumber = entry['NordicNumber'].toString();
          final batchNumber = entry['BatchNumber'];

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
            'departments': selectedDepartment.isNotEmpty
                ? matchingDepartments
                : departmentList,
          };
        }).toList();
        widget.onSearch(searchData);
      } else {
        print('Search request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during search: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataFetched) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: const Text('Filter'),
      content: SingleChildScrollView(
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
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 36,
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Avdelning: ",
                      labelStyle: TextStyle(fontSize: 18),
                    ),
                    textAlign: TextAlign.left),
                onChanged: (String? value) {
                  setState(() {
                    selectedDepartment = value!;
                  });
                }),
            TextFormField(
              controller: batchController,
              decoration: const InputDecoration(
                  labelText: 'Batchnummer: ', hintText: 'Fyll i batchnummer '),
            ),
            DropdownSearch<String>(
                items: products,
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
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 36,
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Produkt: ",
                    labelStyle: TextStyle(fontSize: 18),
                    hintText: "Fyll i",
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    selectedProductName = value!;
                  });
                }),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Utgångsdatum:',
                hintText: 'Fyll i utgångsdatum ',
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            searchButtonPressed();
            print(dateController);
            Navigator.of(context).pop();
          },
          child: const Text('Sök'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Avbryt'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    batchController.dispose();
    super.dispose();
  }
}
