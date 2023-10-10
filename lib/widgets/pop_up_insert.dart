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
      title: Text('Search'),
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
      )
      
       
        
      
    
  }
}
