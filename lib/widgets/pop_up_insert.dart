import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class PopUpInsert extends StatefulWidget {
  @override
  _PopUpInsert createState() => _PopUpInsert();
}

class _PopUpInsert extends State<PopUpInsert> {
  TextEditingController dateController = TextEditingController();
 // TextEditingController otherController1 = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController produktkodController = TextEditingController();
  TextEditingController produktnamnController = TextEditingController();

  List<String> departmentNames = ['Department 1', 'Department 2', 'Department 3'];
  String selectedDepartment = '';
  

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      
      title: const Text('Filter'),
      content: SingleChildScrollView(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //TextFormField(
            //controller: otherController1,
            //decoration: InputDecoration(labelText: 'Avdelning:',
           // hintText: 'fyll i avdelning '),
         // ),

           
          // 如果选择了自定义，显示文本输入框
          


      DropdownSearch<String>(
         popupProps:  const PopupProps.menu(
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
              
            )


         ),

         
         
         dropdownButtonProps: DropdownButtonProps(
           icon: const Icon(Icons.arrow_drop_down_circle_outlined),
           iconSize: 36,
           
         ),
        items: departmentNames,
        
       
         
         dropdownDecoratorProps: const DropDownDecoratorProps(
         dropdownSearchDecoration: InputDecoration(
            labelText: "Avdelning: ",
            labelStyle: TextStyle(fontSize: 18),
            hintText: "Fyll i",
        ),
        
    ),
         onChanged: (String? value) {
          setState(() {
            selectedDepartment = value!;
          });
         }
         
        ),
          TextFormField(
            controller: batchController,
            decoration: const InputDecoration(labelText: 'Batch NR: ',
            hintText: 'fyll i batch nr '),
          ),
          TextFormField(
            controller: produktkodController,
            decoration: const InputDecoration(labelText: 'Produktkod: ',
            hintText: 'fyll i produktkod ',),
          ),
          TextFormField(
            controller: produktnamnController,
            decoration: const InputDecoration(labelText: 'Produktnamn/varunr: ',
            hintText: 'fyll i produktnamn/varunr',),
          ),
          TextField(
            controller: dateController,
            decoration: const InputDecoration(
              labelText: 'Utgångsdatum:',
              hintText: 'fyll i utgångsdatum ',),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),


        ],
      ),
      ),
      actions:[
        ElevatedButton(
          onPressed: () {

             


            
            // Get the date from the date picker
            String date = dateController.text;

            // Get the text from the text fields
            String input1 = selectedDepartment;
            String input2 = batchController.text;
            String input3 = produktkodController.text;
            String input4 = produktnamnController.text;

               
           // logic for what happens when button is pressed
            print('Date: $date');
            print('1: $input1');
            print('2: $input2');
            print('3: $input3');
            print('4: $input4');  
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
    produktnamnController.dispose();
    super.dispose();
  }
}
