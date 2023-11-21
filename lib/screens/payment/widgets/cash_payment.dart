import 'package:flutter/material.dart';

class CashPaymentScreen extends StatelessWidget {
  const CashPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cash Payment',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF33c072),
      ),
      body: const Center(
        child: Text('This is the Cash Payment Screen'),
      ),
    );
  }
}
