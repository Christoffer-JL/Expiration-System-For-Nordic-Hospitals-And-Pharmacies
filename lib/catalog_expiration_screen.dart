import 'package:flutter/material.dart';

class CatalogExpirationScreen extends StatelessWidget {
  const CatalogExpirationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog Expiration Screen'),
      ),
      body: const Center(
        child: Text('Catalog Expiration Details'),
      ),
    );
  }
}
