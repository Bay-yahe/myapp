import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Help Center'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color(0xFF33c072),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(
                -0.3, -0.3), // Adjust the values to reduce the size of 'begin'.
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.green],
          ),
        ),
        child: Center(
          child: ListView(
            children: const <Widget>[
              Center(
                child: HelpTopicCard(
                  title: 'How to Book a Ride?',
                  description: 'Learn how to book a ride using our app.',
                ),
              ),
              Center(
                child: HelpTopicCard(
                  title: 'Payment Issues',
                  description: 'Troubleshoot payment-related problems.',
                ),
              ),
              Center(
                child: HelpTopicCard(
                  title: 'Contact Customer Support',
                  description: 'Reach out to our support team for assistance.',
                ),
              ),
              // Add more HelpTopicCard widgets for different topics.
            ],
          ),
        ),
      ),
    );
  }
}

class HelpTopicCard extends StatelessWidget {
  final String title;
  final String description;

  const HelpTopicCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
