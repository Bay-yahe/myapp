import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber-like Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BookingScreen(),
    );
  }
}

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TextEditingController pickupController = TextEditingController();
  TextEditingController dropoffController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  GoogleMapController? mapController;
  Marker? pickupMarker;
  Marker? dropoffMarker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Ride - Step 1'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(0.0, 0.0),
                zoom: 12.0,
              ),
              markers: Set.from([pickupMarker, dropoffMarker]
                  .where((marker) => marker != null)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: pickupController,
                  decoration: const InputDecoration(labelText: 'Pickup Location'),
                ),
                TextField(
                  controller: dropoffController,
                  decoration: const InputDecoration(labelText: 'Dropoff Location'),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Ride Date'),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Ride Time'),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _updateMarkers();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewScreen(
                          pickup: pickupController.text,
                          dropoff: dropoffController.text,
                          date: dateController.text,
                          time: timeController.text,
                          pickupLocation: LatLng(
                              pickupMarker!.position.latitude,
                              pickupMarker!.position.longitude),
                          dropoffLocation: LatLng(
                              dropoffMarker!.position.latitude,
                              dropoffMarker!.position.longitude),
                        ),
                      ),
                    );
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _updateMarkers() {
    setState(() {
      pickupMarker = Marker(
        markerId: const MarkerId('pickup'),
        position: const LatLng(37.7749,
            -122.4194), // Default coordinates for pickup (San Francisco, CA)
        infoWindow: const InfoWindow(title: 'Pickup'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );

      dropoffMarker = Marker(
        markerId: const MarkerId('dropoff'),
        position: const LatLng(37.7749,
            -122.4194), // Default coordinates for dropoff (San Francisco, CA)
        infoWindow: const InfoWindow(title: 'Dropoff'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });
  }
}

class ReviewScreen extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final String date;
  final String time;
  final LatLng pickupLocation;
  final LatLng dropoffLocation;

  const ReviewScreen({super.key, 
    required this.pickup,
    required this.dropoff,
    required this.date,
    required this.time,
    required this.pickupLocation,
    required this.dropoffLocation,
  });

  Future<void> _sendBookingToServer() async {
    const url =
        'YOUR_SERVER_ENDPOINT'; // Replace with your actual server endpoint

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'pickup': pickup,
        'dropoff': dropoff,
        'date': date,
        'time': time,
        'pickupLocation': {
          'latitude': pickupLocation.latitude,
          'longitude': pickupLocation.longitude,
        },
        'dropoffLocation': {
          'latitude': dropoffLocation.latitude,
          'longitude': dropoffLocation.longitude,
        },
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Booking sent successfully');
      // Add any additional actions upon successful server response
    } else {
      print('Failed to send booking. Status code: ${response.statusCode}');
      // Handle error, show error message, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Booking - Step 2'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {},
              initialCameraPosition: const CameraPosition(
                target: LatLng(0.0, 0.0),
                zoom: 12.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('pickup'),
                  position: pickupLocation,
                  infoWindow: const InfoWindow(title: 'Pickup'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                ),
                Marker(
                  markerId: const MarkerId('dropoff'),
                  position: dropoffLocation,
                  infoWindow: const InfoWindow(title: 'Dropoff'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Review your booking details:'),
                const SizedBox(height: 10),
                Text('Pickup Location: $pickup'),
                Text('Dropoff Location: $dropoff'),
                Text('Ride Date: $date'),
                Text('Ride Time: $time'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm Booking'),
                          content: const Text('Do you want to confirm this booking?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _sendBookingToServer();
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Confirm Booking'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
