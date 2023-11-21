import 'package:flutter/material.dart';

class Transaction extends StatelessWidget {
  const Transaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF33c072),
      ),
      body: Center(
        child: ListView(
          children: const <Widget>[
            Center(
              child: TransactionCard(
                title: 'Bayan-Tranca',
                description: 'Regular TransFee',
              ),
            ),
            Center(
              child: TransactionCard(
                title: 'Bayan-Tranca',
                description: 'Special TransFee',
              ),
            ),
            Center(
              child: TransactionCard(
                title: 'Bayan-Tranca',
                description: 'Student TransFee',
              ),
            ),
            // Add more TransactionCard widgets for different transactions.
          ],
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String title;
  final String description;

  const TransactionCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Wrap with a Container to set the width
      width: 300.0, // Set the desired width here
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          onTap: () {
            // Add functionality to navigate to specific help content.
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
