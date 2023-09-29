import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final TextEditingController _textFieldController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _navigateToSecondScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Rs216StartskRm(),
      ),
    );
  }

  Future<void> _sendDataToServer(String data) async {
    final url = Uri.parse('http://localhost:3000/api-endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'data': data}),
    );

    Future<DocumentSnapshot> getData() async {
      await Firebase.initializeApp();
      return await FirebaseFirestore.instance
          .collection("users")
          .doc("docID")
          .get();
    }

    if (response.statusCode == 200) {
    } else {}
  }

  Future<void> _sendDataToServer2(String data) async {
    final url = Uri.parse('http://localhost:3000/api-endpoint2');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'data': data}),
    );

    if (response.statusCode == 200) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(
                labelText: 'Enter some text',
              ),
            ),
            ElevatedButton(
              onPressed: _navigateToSecondScreen,
              child: Text('Go to Second Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                String enteredText = _textFieldController.text;
                _sendDataToServer(enteredText);
              },
              child: const Text('Send to Server'),
            ),
            TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(
                labelText: 'Enter data for table 2',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('testCollection').add({
                  'name': 'John Doe',
                  'email': 'johndoe@example.com',
                });
              },
              child: const Text('Send to Table 2'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Text('This is the second screen!'),
      ),
    );
  }
}

class Rs216StartskRm extends StatelessWidget {
  const Rs216StartskRm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF97FFAE),
      child: Center(
        child: Align(
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 40,
                top: 168,
                child: Container(
                  width: 216,
                  height: 76,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF73C9DF),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 51,
                top: 182,
                child: SizedBox(
                  width: 194,
                  height: 49,
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 12),
                    child: Text(
                      'Registrera',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: 'Inika',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 40,
                top: 392,
                child: Container(
                  width: 216,
                  height: 76,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFDDD41),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 40,
                top: 405,
                child: SizedBox(
                  width: 194,
                  height: 49,
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 12),
                    child: Text(
                      'Katalog',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: 'Inika',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 274,
                top: 161,
                child: Container(
                  width: 82,
                  height: 93,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/82x93"),
                      fit: BoxFit.fill,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 268,
                top: 385,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/90x90"),
                      fit: BoxFit.fill,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
