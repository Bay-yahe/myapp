import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePic extends StatelessWidget {
  ProfilePic({super.key});

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? currentUserEmail = user?.email;

    return StreamBuilder<QuerySnapshot>(
      stream: users.where('email', isEqualTo: currentUserEmail).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        } else if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildNoDataState();
        } else {
          var data = snapshot.data!.docs[0].data() as Map<String, dynamic>;
          return _buildProfileWidget(data);
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 118, 230, 168),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 118, 230, 168),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),
      child: Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildNoDataState() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 118, 230, 168),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),
      child: const Center(
        child: Text('No data found.'),
      ),
    );
  }

  Widget _buildProfileWidget(Map<String, dynamic> data) {
    String? profileImageUrl = user.photoURL;

    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 118, 230, 168),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),
      child: Row(
        children: [
          if (profileImageUrl != null)
            Image.network(
              profileImageUrl,
              width: 100.0,
              height: 100.0,
            )
          else
            const CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 50.0,
                color: Colors.white,
              ),
            ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                data['email'],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
