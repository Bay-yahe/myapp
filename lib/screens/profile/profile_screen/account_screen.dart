import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();
  File? imageFile;

  final user = FirebaseAuth.instance.currentUser!;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Function to fetch user data from Firestore
  Future<Map<String, dynamic>> getUserData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await users
        .where('email', isEqualTo: user.email)
        .get() as QuerySnapshot<Map<String, dynamic>>;

    if (querySnapshot.size > 0) {
      return querySnapshot.docs.first.data();
    } else {
      return {}; // Return an empty map if no matching user is found
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch user data when the screen initializes
    getUserData().then((data) {
      setState(() {
        // Set the retrieved data to your controllers
        nameController.text = data['name'] ?? '';
        contactNumberController.text = data['contactnumber'] ?? '';
        homeAddressController.text = data['address'] ?? '';
        birthdayController.text = data['birthdate'] ?? '';
      });
    });
  }

  Future<void> showImagePicker() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle any potential errors when picking an image.
      print("Error picking an image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF33c072),
        title: const Text(
          "My Account",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.3, -0.3),
            end: Alignment.bottomRight,
            colors: [Colors.white, Color.fromARGB(255, 191, 228, 192)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: showImagePicker,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          child: ClipOval(
                            child: Container(
                              width: 120,
                              height: 120,
                              color: Colors.white,
                              child: imageFile != null
                                  ? Image.file(
                                      imageFile!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      user.photoURL!, // Use the user's photoURL directly
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF33c072),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                buildListTile(
                  "Name",
                  nameController,
                  FontAwesomeIcons.user,
                  subtext: nameController.text,
                ),
                buildListTile(
                  "Contact Number",
                  contactNumberController,
                  FontAwesomeIcons.phone,
                  subtext: contactNumberController.text,
                ),
                buildListTile(
                  "Home Address",
                  homeAddressController,
                  FontAwesomeIcons.home,
                  subtext: homeAddressController.text,
                ),
                buildListTile(
                  "Email Address",
                  emailAddressController,
                  FontAwesomeIcons.envelope,
                  showEditButton: false,
                  subtext: user.email,
                ),
                buildListTile(
                  "Birthday",
                  birthdayController,
                  FontAwesomeIcons.birthdayCake,
                  showEditButton: false,
                  subtext: birthdayController.text,
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement logic to save changes
                      // You can access all the edited information from the controllers
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF33c072),
                    ),
                    child: const Text("Save Changes"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildListTile(
    String title,
    TextEditingController controller,
    IconData iconData, {
    bool showEditButton = true,
    String? subtext,
  }) {
    return ListTile(
      leading: FaIcon(iconData),
      title: Text(title),
      subtitle: subtext != null ? Text(subtext) : null,
      trailing: showEditButton
          ? IconButton(
              icon: const FaIcon(FontAwesomeIcons.edit),
              onPressed: () {
                showEditDialog(title, controller);
              },
            )
          : null,
    );
  }

  void showEditDialog(String fieldName, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $fieldName"),
          content: TextFormField(
            controller: controller,
            decoration: InputDecoration(labelText: fieldName),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
