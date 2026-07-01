import 'package:flutter/material.dart';

class RideScreen extends StatelessWidget {
  const RideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('noma'),
      ),
      body: const Center(
        child: Text('Ride'),
      ),
    );
  }
}
