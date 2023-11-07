import 'package:flutter/material.dart';

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Screen'),
      ),
      body: const Center(
        child: Text('This is the Department Screen'),
      ),
    );
  }
}
