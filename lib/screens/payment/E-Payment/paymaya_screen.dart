import 'package:flutter/material.dart';

class PayMayaPaymentScreen extends StatelessWidget {
  const PayMayaPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PayMaya Payment',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF33c072),
      ),
      body: const Center(
        child: Text('This is the PayMaya Payment Screen'),
      ),
    );
  }
}
