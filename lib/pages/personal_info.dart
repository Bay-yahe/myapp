//import 'dart:developer';
//import 'dart:ffi';

import 'package:bay_yahe_app/screens/main/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MM-dd-yyyy');
    return Scaffold(
      backgroundColor: Colors.greenAccent[100],
      appBar: AppBar(
        title: const Text('Personal Information'),
        backgroundColor: Colors.greenAccent[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: firstnameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (firstname) {
                  if (firstname == null || firstname.isEmpty) {
                    return 'Please enter your First Name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lastnameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (lastname) {
                  if (lastname == null || lastname.isEmpty) {
                    return 'Please enter your Last Name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: contactNumberController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number (Philippine format)',
                ),
                validator: (contact) {
                  if (contact == null || contact.isEmpty) {
                    return 'Please enter your contact number';
                  }
                  return null; // You can add more validation here if needed
                },
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Home Address'),
                validator: (address) {
                  if (address == null || address.isEmpty) {
                    return 'Please enter your home address';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Birthday (MM-DD-YYYY)',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context); // Show the date picker
                    },
                  ),
                ),
                validator: (birthdate) {
                  if (birthdate == null || birthdate.isEmpty) {
                    return 'Please enter your birthday';
                  }
                  return null;
                },
                controller: TextEditingController(
                  text: selectedDate != null
                      ? dateFormat.format(selectedDate!)
                      : '', // Display selected date in the text field
                ),
                readOnly: true, // Make the text field read-only
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // Retrieve the currently logged-in user's email
            User? user = FirebaseAuth.instance.currentUser;
            String? userEmail = user?.email;

            // Create a map of the form data including the user's email
            Map<String, dynamic> formData = {
              'firstname': firstnameController.text,
              'lastname': lastnameController.text,
              'contactNumber': contactNumberController.text,
              'address': addressController.text,
              'birthday':
                  selectedDate != null ? dateFormat.format(selectedDate!) : '',
              'email': userEmail, // Add user's email to the data
            };

            // Call the function to add data to Firestore
            await FirebaseFirestore.instance
                .collection('client_user')
                .add(formData);

            // Navigate to the next page when the form is valid.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          }
        },
        child: const Text('Proceed'),
      ),
    );
  }
}
