import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
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

  Future<void> _sendDataToServer(String data) async {
    final url = Uri.parse(
        'https://your-api-endpoint.com'); // Replace with your API endpoint
    final response = await http.post(
      url,
      body: {
        'data': data, // The data from the TextField
      },
    );
    if (response.statusCode == 200) {
      // Data sent successfully
    } else {
      // Handle errors here
    }
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
              onPressed: () {
                String enteredText = _textFieldController.text;
                _sendDataToServer(enteredText);
              },
              child: const Text('Send to Server'),
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
