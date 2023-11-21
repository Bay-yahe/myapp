import 'package:bay_yahe_app/pages/Login_Or_Register_Page.dart';
import 'package:bay_yahe_app/pages/personal_info.dart';
import 'package:bay_yahe_app/screens/main/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  Future<bool> isUserInDatabase(String userEmail) async {
    // Reference to Firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Perform a query to check if the user with the specified email exists in Firestore
    QuerySnapshot<Object?> querySnapshot =
        await users.where('email', isEqualTo: userEmail).get();

    return querySnapshot.docs.isNotEmpty;
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
                  // If the database check is still ongoing, you can show a loading indicator.
                  return CircularProgressIndicator();
                } else if (databaseSnapshot.hasData) {
                  // Check if the user is in the database
                  if (databaseSnapshot.data!) {
                    return const MainScreen();
                  } else {
                    return const PersonalInfoPage();
                  }
                } else {
                  // Handle error if the database check fails
                  return Text('Error checking database');
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
