import 'package:flutter/material.dart';

class PickupDestinationPage extends StatefulWidget {
  final bool isPickup;
  final ValueChanged<String> onLocationSelected;

  PickupDestinationPage({
    required this.isPickup,
    required this.onLocationSelected,
  });

  @override
  _PickupDestinationPageState createState() => _PickupDestinationPageState();
}

class _PickupDestinationPageState extends State<PickupDestinationPage> {
  String location = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPickup ? 'Pickup Location' : 'Destination'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                  labelText:
                      'Enter ${widget.isPickup ? 'pickup' : 'destination'} location'),
              onChanged: (value) {
                setState(() {
                  location = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (location.isNotEmpty) {
                  widget.onLocationSelected(location);
                  Navigator.pop(context);
                } else {
                  // Handle case when location is not provided
                  // You may want to show a message or prevent navigation
                }
              },
              child: Text('Set ${widget.isPickup ? 'Pickup' : 'Destination'}'),
            ),
          ],
        ),
      ),
    );
  }
}
