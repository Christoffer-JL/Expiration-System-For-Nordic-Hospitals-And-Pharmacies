import 'package:flutter/material.dart';
import 'widgets/pop_up.dart'; // Import your PopUp widget
import 'widgets/pop_up_insert.dart';

class CatalogStartScreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CustomImageButton(
                    imagePath: 'assets/shin.jfif', // Provide the path to your image asset
                    onPressed: () {
                      Navigator.pushNamed(context, '/catalog_expiration');
                    },
                  ),
                  SizedBox(width: 15),
                  CustomImageButton(
                    imagePath: 'assets/pingu.jpg', // Provide the path to your image asset
                    onPressed: () 
                    {
                      showDialog(
                        context: context, 
                        builder:(BuildContext context){
                        return PopUpInsert();
                      }

                                           ) ; // Show the popup when the button is pressed
                    },
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: Text(
              'catalog start screen',
              style: TextStyle(
                fontSize: 20, // Set the font size of the text
                fontWeight: FontWeight.bold, // Set the font weight of the text
                color: Colors.black, // Set the color of the text
              ),
            ),
          ),
        ],
      ),
    );
  }
}
        

class CustomImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  CustomImageButton({
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Image.asset(
        imagePath,
        width: 50, // Set the width of the image
        height: 50, // Set the height of the image
      ),
    );
  }
}





