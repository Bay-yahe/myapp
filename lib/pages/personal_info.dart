//import 'dart:developer';
//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'image_upload.dart';

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
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Create a map of the form data
            Map<String, dynamic> formData = {
              'firstname': firstnameController.text,
              'lastname': lastnameController.text,
              'contactNumber': contactNumberController.text,
              'address': addressController.text,
              'birthday':
                  selectedDate != null ? dateFormat.format(selectedDate!) : '',
            };

            // Call the function to add data to Firestore

            FirebaseFirestore.instance.collection('client_user').add(formData);

            // Navigate to the next page when the form is valid.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ImageUpload()),
            );
          }
        },
        child: const Text('Proceed'),
      ),
    );
  }
}

//Future<void> addDataToFirestore(Map<String, dynamic> formData) async {
//  FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//  try {
//    await firestore.collection('users').add(formData);
//  } catch (e) {
//    print('Error adding data to Firestore: $e');
//  }
//}

//class User {
//  final String firstname;
//  final String lastname;
//  final Long contact;
//  final String address;
//  final DateFormat birthdate;
//  final String? id;

//  User(
//      {required this.firstname,
//      required this.lastname,
//      required this.contact,
//      required this.address,
//      required this.birthdate,
//      this.id});
//
//  factory User.fromJson(Map<String, dynamic> json) {
//    return User(
//        firstname: json['firstname'],
//        lastname: (json['lastname']),
//        contact: json['contact'],
//        address: json['address'],
//        birthdate: json['birthdate'],
//        id: json['id']);
//  }

//  toJson() {
//    return {
 //     'firstname': firstname,
//      'lastname': lastname,
//      'contact': contact,
//      'address': address,
//      'birthdate': birthdate,
//      'id': id
//    };
//  }
//}

//Instantiate Firestore
//final db = FirebaseFirestore.instance;

//reguser({firstname, lastname, contact, address, birthdate}) async {
//  final docRef = db.collection('User').doc();
//  User NU = User(
//      firstname: firstname,
//      lastname: lastname,
//      contact: contact,
//      birthdate: birthdate,
//      address: address,
//      id: docRef.id);
//
//  await docRef.set(NU.toJson()).then(
//      (value) => log("Appointment booked successfully!"),
//      onError: (e) => log("Error booking appointment: $e"));
//}
