import 'package:flutter/material.dart';

class GcashPaymentScreen extends StatelessWidget {
  const GcashPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'G-Cash',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF33c072),
      ),
      body: const Center(
        child: Text('This is the G-cash Payment Screen'),
      ),
    );
  }
}
