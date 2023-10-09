import 'package:flutter/material.dart';

class PopUpInsert extends StatelessWidget {
 
 
  @override
  Widget build (BuildContext context) {
    return AlertDialog(
      title: Text('Search'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Avdlning:',
              hintText: 'fyll i',
            ),
          ),

          TextField(
            decoration: InputDecoration(
              labelText: 'Batch Nr::',
              hintText: 'fyll i',
            ),
          ),

          TextField(
            decoration: InputDecoration(
              labelText: 'Produktkod:',
              hintText: 'fyll i',
            ),
          ),

          TextField(
            decoration: InputDecoration(
              labelText: 'ProduktNamn/varunr:',
              hintText: 'fyll i',
            ),
          ),

          TextField(
            decoration: InputDecoration(
              labelText: ':',
              hintText: 'fyll i',
            ),
          ),


        ],
      ),
      )
      
       
        
      
    
  }
}
