import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CashInOptions extends StatelessWidget {
  const CashInOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Cash-In Options',
              style: TextStyle(color: Colors.black),
            ),
          ),
          backgroundColor: const Color(0xFF33c072),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Implement navigation to go back to the previous screen
              Navigator.pop(context);
            },
          ),
        ),
        body: const CashInOptionsScreen(),
      ),
    );
  }
}

class CashInOptionsScreen extends StatelessWidget {
  const CashInOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CashInOptionCard(
          text: 'Gcash',
          imageAsset:
              'assets/logo/g-cash.png', // Replace with your image asset path
          icon: FontAwesomeIcons.plus,
          context: context, // Pass the context for navigation
        ),
        CashInOptionCard(
          text: 'Paymaya',
          imageAsset:
              'assets/logo/paymaya.png', // Replace with your image asset path
          icon: FontAwesomeIcons.plus,
          context: context, // Pass the context for navigation
        ),
      ],
    );
  }
}

class CashInOptionCard extends StatelessWidget {
  final String text;
  final String imageAsset;
  final IconData icon;
  final BuildContext context;

  const CashInOptionCard({super.key, 
    required this.text,
    required this.imageAsset,
    required this.icon,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  imageAsset,
                  width: 50, // Set the image width as needed
                  height: 50, // Set the image height as needed
                ),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Handle button press
                // You can add the desired action here

                // For example, you can navigate to a new screen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CashInDetailsScreen(text: text)),
                );
              },
              icon: Icon(icon),
              label: const Text('Cash-In'),
            ),
          ],
        ),
      ),
    );
  }
}

class CashInDetailsScreen extends StatelessWidget {
  final String text;

  const CashInDetailsScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$text Cash-In Details'),
      ),
      body: Center(
        child: Text('Cash-In details for $text go here.'),
      ),
    );
  }
}
