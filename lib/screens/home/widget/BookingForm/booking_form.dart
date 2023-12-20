import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pickup_destination_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BookingForm(),
    );
  }
}

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  String bookingStatus = 'ASAP';
  String pickupLocation = 'Select Pickup Location';
  String destination = 'Select Destination';
  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                _showBookingStatusDialog();
              },
              child: Text('Booking Status: $bookingStatus'),
            ),
            if (bookingStatus == 'Scheduled') ...[
              SizedBox(height: 16),
              Text(
                  'Selected Date: ${selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : 'Not set'}'),
              SizedBox(height: 8),
              Text(
                  'Selected Time: ${selectedTime != null ? selectedTime!.format(context) : 'Not set'}'),
              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text('Select Time'),
                  ),
                ],
              ),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _navigateToPickupDestinationPage(true);
              },
              child: Text('Pickup Location: $pickupLocation'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _navigateToPickupDestinationPage(false);
              },
              child: Text('Destination: $destination'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _submitBooking();
              },
              child: Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBookingStatusDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Booking Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    bookingStatus = 'ASAP';
                  });
                  Navigator.of(context).pop();
                },
                child: Text('ASAP'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    bookingStatus = 'Scheduled';
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Scheduled'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToPickupDestinationPage(bool isPickup) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickupDestinationPage(
          isPickup: isPickup,
          onLocationSelected: (location) {
            setState(() {
              if (isPickup) {
                pickupLocation = location;
              } else {
                destination = location;
              }
            });
          },
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _submitBooking() {
    print('Booking Status: $bookingStatus');
    print('Pickup Location: $pickupLocation');
    print('Destination: $destination');

    if (bookingStatus == 'Scheduled') {
      print(
          'Selected Date: ${selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : 'Not set'}');
      print(
          'Selected Time: ${selectedTime != null ? selectedTime!.format(context) : 'Not set'}');
    }
  }
}
