import 'package:flutter/material.dart';

class PickupDestinationPage extends StatelessWidget {
  final bool isDestination;
  final ValueChanged<String> onLocationSelected;

  const PickupDestinationPage({
    Key? key,
    required this.isDestination,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isDestination ? 'Destination' : 'Pickup Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select ${isDestination ? 'Destination' : 'Pickup'} Location',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Assume you have some location selection logic here
                String selectedLocation =
                    'Selected Location'; // Replace with actual logic
                onLocationSelected(selectedLocation);
                Navigator.pop(context); // Close the location selection page
              },
              child: Text('Select Location'),
            ),
          ],
        ),
      ),
    );
  }
}
