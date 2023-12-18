import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Ride'),
      ),
      body: Padding(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewScreen(
                      pickup: pickupController.text,
                      dropoff: dropoffController.text,
                      date: dateController.text,
                      time: timeController.text,
                    ),
                  ),
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewScreen extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final String date;
  final String time;

  const ReviewScreen(
      {super.key, required this.pickup,
      required this.dropoff,
      required this.date,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Booking'),
      ),
      body: Padding(
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
                // Add confirmation logic here
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Booking Confirmed'),
                      content: const Text('Your ride has been booked!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                          child: const Text('OK'),
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
    );
  }
}
