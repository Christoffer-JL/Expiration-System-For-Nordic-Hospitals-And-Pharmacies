import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PopUpInsert extends StatefulWidget {
  @override
  _PopUpInsert createState() => _PopUpInsert();
}

class _PopUpInsert extends State<PopUpInsert> {
  TextEditingController dateController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController produktkodController = TextEditingController();
  TextEditingController produktnamnController = TextEditingController();

  List<String> departmentNames = [];
  List<String> productNamns = [];
  String selectedDepartment = '';
  String selectedProductNamn = '';
  bool isDataFetched = false;

  Future<void> fetchDepaarmentFromServer() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/all-departments'));
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
      final response =
          await http.get(Uri.parse('http://localhost:3000/entries'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          productNamns = data
              .map((entry) =>
                  '${entry['NordicNumber']}, ${entry['ArticleName']}, ${entry['Packaging']}')
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

  @override
  Widget build(BuildContext context) {
    if (!isDataFetched) {
      return Center(
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
                dropdownButtonProps: DropdownButtonProps(
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
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
            TextFormField(
              controller: batchController,
              decoration: const InputDecoration(
                  labelText: 'Batch NR: ', hintText: 'Fyll i batch nr '),
            ),
            TextFormField(
              controller: produktkodController,
              decoration: const InputDecoration(
                labelText: 'Produktkod: ',
                hintText: 'Fyll i produktkod ',
              ),
            ),
            DropdownSearch<String>(
                items: productNamns,
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
                dropdownButtonProps: DropdownButtonProps(
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
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
                    selectedProductNamn = value!;
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
            // Get the date from the date picker
            String date = dateController.text;

            // Get the text from the text fields
            String input1 = selectedDepartment;
            String input2 = batchController.text;
            String input3 = produktkodController.text;
            // String input4 = produktnamnController.text;
            String input4 = selectedProductNamn;

            // logic for what happens when button is pressed
            print('Date: $date');
            print('Department: $input1');
            print('Batch: $input2');
            print('ProductCode: $input3');
            print('ProductName: $input4');
            print(departmentNames);
            print(productNamns);
            // Close the pop up window
            Navigator.of(context).pop();
          },
          child: const Text('Search'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    // otherController1.dispose();
    batchController.dispose();
    produktkodController.dispose();
    // produktnamnController.dispose();
    super.dispose();
  }
}
