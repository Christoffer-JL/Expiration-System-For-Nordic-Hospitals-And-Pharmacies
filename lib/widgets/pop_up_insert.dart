import 'package:flutter/material.dart';

class PopUpInsert extends StatefulWidget {
  @override
  _PopUpInsert createState() => _PopUpInsert();
}

class _PopUpInsert extends State<PopUpInsert> {
  TextEditingController dateController = TextEditingController();
  TextEditingController otherController1 = TextEditingController();
  TextEditingController otherController2 = TextEditingController();
  TextEditingController otherController3 = TextEditingController();
  TextEditingController otherController4 = TextEditingController();

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
    return AlertDialog(
      title: Text('Filter'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: otherController1,
            decoration: InputDecoration(labelText: 'Avdelning:',
            hintText: 'fyll i avdelning '),
          ),
          TextFormField(
            controller: otherController2,
            decoration: InputDecoration(labelText: 'Batch NR: ',
            hintText: 'fyll i batch nr '),
          ),
          TextFormField(
            controller: otherController3,
            decoration: InputDecoration(labelText: 'Produktkod: ',
            hintText: 'fyll i produktkod ',),
          ),
          TextFormField(
            controller: otherController4,
            decoration: InputDecoration(labelText: 'Produktnamn/varunr: ',
            hintText: 'fyll i produktnamn/varunr',),
          ),
          TextField(
            controller: dateController,
            decoration: InputDecoration(
              labelText: 'Utgångsdatum:',
              hintText: 'fyll i utgångsdatum ',),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            
            // Get the date from the date picker
            String date = dateController.text;
            // Get the text from the text fields
            String input1 = otherController1.text;
            String input2 = otherController2.text;
            String input3 = otherController3.text;
            String input4 = otherController4.text;

               
           // logic for what happens when button is pressed
            print('Date: $date');
            print('1: $input1');
            print('2: $input2');
            print('3: $input3');
            print('4: $input4');  
            // Close the pop up window
            Navigator.of(context).pop();
          },
          child: Text('Search'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    
    dateController.dispose();
    otherController1.dispose();
    otherController2.dispose();
    otherController3.dispose();
    otherController4.dispose();
    super.dispose();
  }
}
