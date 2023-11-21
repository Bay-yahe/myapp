import 'package:flutter/material.dart';

class CommunicationScreen extends StatelessWidget {
  const CommunicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Communication Settings',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF33c072),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const CommunicationSettings(),
    );
  }
}

class CommunicationSettings extends StatefulWidget {
  const CommunicationSettings({super.key});

  @override
  _CommunicationSettingsState createState() => _CommunicationSettingsState();
}

class _CommunicationSettingsState extends State<CommunicationSettings> {
  bool allowUpdates = true;
  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Updates',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: const Text('Allow Auto-updates'),
            trailing: Switch(
              value: allowUpdates,
              onChanged: (bool value) {
                setState(() {
                  allowUpdates = value;
                });
              },
            ),
          ),
          const Text(
            'Feedback',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: feedbackController,
            decoration: const InputDecoration(
              hintText: 'Write your feedback',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle the feedback submission here
              String feedback = feedbackController.text;
              // Send the feedback
              print('Feedback submitted: $feedback');
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }
}
