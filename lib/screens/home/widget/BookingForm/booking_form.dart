import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class BookingForm extends StatefulWidget {
  const BookingForm({Key? key});

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  bool isScheduled = false;
  bool showLocationError = false;
  bool showDestinationError = false;

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          selectedDate.isBefore(currentDate) ? currentDate : selectedDate,
      firstDate: currentDate,
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<double> _getDistance(String origin, String destination) async {
    try {
      final List<Location> originLocations = await locationFromAddress(origin);
      final List<Location> destinationLocations =
          await locationFromAddress(destination);

      if (originLocations.isNotEmpty && destinationLocations.isNotEmpty) {
        final Uri uri = Uri.parse(
          'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${originLocations[0].latitude},${originLocations[0].longitude}&destinations=${destinationLocations[0].latitude},${destinationLocations[0].longitude}&key=YOUR_GOOGLE_MAPS_API_KEY',
        );

        final http.Response response = await http.get(uri);
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'OK' &&
            data.containsKey('rows') &&
            data['rows'].isNotEmpty &&
            data['rows'][0].containsKey('elements') &&
            data['rows'][0]['elements'].isNotEmpty &&
            data['rows'][0]['elements'][0].containsKey('distance') &&
            data['rows'][0]['elements'][0]['distance'].containsKey('value')) {
          final double distanceInMeters =
              data['rows'][0]['elements'][0]['distance']['value'];
          final double distanceInKm = distanceInMeters / 1000;

          return distanceInKm;
        }
      }
    } catch (e) {
      print('Error: $e');
    }

    return 0.0;
  }

  Future<void> computeAndBookNow() async {
    if (locationController.text.isEmpty) {
      setState(() {
        showLocationError = true;
      });
      return;
    }

    if (destinationController.text.isEmpty) {
      setState(() {
        showDestinationError = true;
      });
      return;
    }

    // Use the new _getDistance function to compute distance
    final distanceInKm = await _getDistance(
      locationController.text,
      destinationController.text,
    );

    final cost = distanceInKm * 10; // Assuming 10 pesos per kilometer

    // Create a new document in the "Booking_Details" collection
    // Note: Add your Firestore instance initialization if not already done
    // await FirebaseFirestore.instance.collection('Booking_Details').add({
    //   'date': isScheduled ? selectedDate : null,
    //   'time': isScheduled ? selectedTime.format(context) : null,
    //   'location': locationController.text,
    //   'destination': destinationController.text,
    //   'distance': distanceInKm,
    //   'cost': cost,
    // });

    // For testing, print the computed distance and cost
    print('Distance: $distanceInKm km');
    print('Cost: $cost pesos');

    // Navigate to the MapScreen after booking
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const MapScreen()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Form',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF33c072),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CheckboxListTile(
              title: const Text('Scheduled Booking'),
              value: isScheduled,
              onChanged: (value) {
                setState(() {
                  isScheduled = value!;
                });
              },
            ),
            if (isScheduled)
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: IgnorePointer(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: "${selectedDate.toLocal()}".split(' ')[0],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      _selectTime(context);
                    },
                    child: IgnorePointer(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        controller: TextEditingController(
                          text: selectedTime.format(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                errorText:
                    showLocationError ? 'Location cannot be empty' : null,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: destinationController,
              decoration: InputDecoration(
                labelText: 'Destination',
                border: OutlineInputBorder(),
                errorText:
                    showDestinationError ? 'Destination cannot be empty' : null,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: computeAndBookNow,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF33c072)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.book,
                    color: Colors.black45,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Book Now',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Booking Form'),
      ),
      body: const BookingForm(),
    ),
  ));
}
