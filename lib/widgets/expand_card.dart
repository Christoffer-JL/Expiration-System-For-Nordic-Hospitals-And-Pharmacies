import 'package:flutter/material.dart';

class expandCard extends StatefulWidget {
  final String title;
  final List<String> departments;
  final String nordicNumber;
  final String batchNumber;
  final Future<void> Function() onDelete;

  expandCard({
    required this.title,
    required this.departments,
    required this.nordicNumber,
    required this.onDelete,
    required this.batchNumber,
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
                // Display additional information like Product Code here
                Text(
                  'Varunummer: ${widget.nordicNumber}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Batch Number: ${widget.batchNumber}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Column(
                  children: widget.departments.map((departmentName) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'DepartmentName: $departmentName',
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
                            // Call the onDelete function with departmentName
                            // widget.onDelete(departmentName);
                          },
                        ),
                      ],
                    );
                  }).toList(),
                )
              ],
            ),
        ],
      ),
    );
  }
}
