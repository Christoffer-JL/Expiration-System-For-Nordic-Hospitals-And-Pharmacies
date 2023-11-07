import 'package:flutter/material.dart';

class CatalogStartScreen extends StatelessWidget {
  const CatalogStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog Start Screen'),
      ),
      body: const Center(
        child: Text('Start Your Catalog Here'),
      ),
    );
  }
}
