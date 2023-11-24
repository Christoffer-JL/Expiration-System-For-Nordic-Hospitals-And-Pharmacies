import 'package:flutter/material.dart';
import 'package:flutter_local_test_pca/widgets/pop_up.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
  late MobileScannerController controller;

  @override
  void initState() {
    controller = MobileScannerController();
    super.initState();
    fetchDepartmentFromServer();
  }

  Future<void> fetchDepartmentFromServer() async {
    if (!isDataFetched) {
      try {
        final response =
            await http.get(Uri.parse('${AppConfig.apiUrl}/all-departments'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            departmentNames = data
                .map((entry) => entry['DepartmentName'].toString())
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DepartmentScannerWidget(
            controller: controller,
            overlayColor: Colors.black.withOpacity(0.3),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownSearch<String>(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          )),
                      dropdownButtonProps: const DropdownButtonProps(
                        icon: Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 36,
                      ),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          labelText: "Avdelning:",
                          labelStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                        ),
                        baseStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          selectedDepartment = value!;
                        });
                      }),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    bool isMatch = departmentNames.contains(selectedDepartment);
                    if (isMatch) {
                      controller.stop();
                      Navigator.pushNamed(
                        context,
                        '/qr_scan',
                        arguments: {'selectedDepartment': selectedDepartment},
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PopUp(
                              title: "Hitta inte avdelning",
                              content:
                                  'Avdelningen du söker finns inte i systemet.',
                              buttonText1: '',
                              buttonText2: 'OK',
                              onPressed1: () {
                              },
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            );
                          });
                    }
                    //
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
