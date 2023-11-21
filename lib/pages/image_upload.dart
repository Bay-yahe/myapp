import 'dart:io';
import 'package:bay_yahe_app/screens/main/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({Key? key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<String?> _uploadImageToStorage() async {
    if (_image == null) return null;

    try {
      // Generate a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageReference.putFile(_image!);
      await uploadTask.whenComplete(() => null);

      // Get the download URL for the image
      String imageUrl = await storageReference.getDownloadURL();

      return imageUrl;
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }

  Future<void> _saveImageToFirestore(String imageUrl) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Reference to the user's document in Firestore
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('client_user').doc(user.uid);

        // Check if the document exists
        bool userExists = await userDocRef.get().then((doc) => doc.exists);

        if (userExists) {
          // If the document exists, update the image URL
          await userDocRef.update({'imageUrl': imageUrl});
        } else {
          // If the document doesn't exist, create it with the image URL
          await userDocRef.set({'imageUrl': imageUrl});
        }
      }
    } catch (error) {
      print('Error saving image URL to Firestore: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent[100],
      appBar: AppBar(
        title: const Text('Upload file'),
        backgroundColor: Colors.greenAccent[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(
                    _image!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : const Text('No image selected.'),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Upload the image to Firebase Storage
                String? imageUrl = await _uploadImageToStorage();

                if (imageUrl != null) {
                  // Save the image URL to Firestore
                  await _saveImageToFirestore(imageUrl);

                  // Navigate to the main screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                  );
                } else {
                  // Handle error uploading image
                  // Show a message to the user or take appropriate action
                }
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
