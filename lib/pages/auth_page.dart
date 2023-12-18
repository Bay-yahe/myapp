import 'package:bay_yahe_app/pages/Login_Or_Register_Page.dart';
import 'package:bay_yahe_app/pages/personal_info.dart';
import 'package:bay_yahe_app/screens/main/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  Future<bool> isUserInDatabase(String userEmail) async {
    try {
      // Reference to Firestore collection
      CollectionReference clientUsers =
          FirebaseFirestore.instance.collection('client_user');

      // Perform a query to check if the user with the specified email exists in Firestore
      QuerySnapshot<Object?> querySnapshot =
          await clientUsers.where('email', isEqualTo: userEmail).get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      print('Error checking database: $error');
      return false; // Handle error by returning false
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data!;
            String userEmail = user.email ?? '';

            // Check if the user's email exists in the Firestore database
            return FutureBuilder<bool>(
              future: isUserInDatabase(userEmail),
              builder: (context, databaseSnapshot) {
                if (databaseSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  // If the database check is still ongoing, show a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                } else if (databaseSnapshot.hasData) {
                  // Check if the user is in the database
                  if (databaseSnapshot.data!) {
                    return const MainScreen();
                  } else {
                    return const PersonalInfoPage();
                  }
                } else {
                  // Handle error if the database check fails
                  return const Text('Error checking database');
                }
              },
            );
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
