import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = firestore.collection('users');

  // Create operation
  try {
    await users.add({'name': 'John Doe', 'age': 30});
    print('User added successfully.');
  } catch (e) {
    print('Failed to add user: $e');
  }

  // Read operation
  try {
    QuerySnapshot querySnapshot = await users.get();
    for (var doc in querySnapshot.docs) {
      print('User: ${doc.id}, ${doc.data()}');
    }
  } catch (e) {
    print('Failed to retrieve users: $e');
  }

  // Update operation
  try {
    QuerySnapshot querySnapshot =
        await users.where('name', isEqualTo: 'John Doe').get();
    querySnapshot.docs.forEach((doc) async {
      await users.doc(doc.id).update({'age': 31});
      print('User updated successfully.');
    });
  } catch (e) {
    print('Failed to update user: $e');
  }

  // Delete operation
  try {
    QuerySnapshot querySnapshot =
        await users.where('name', isEqualTo: 'John Doe').get();
    querySnapshot.docs.forEach((doc) async {
      await users.doc(doc.id).delete();
      print('User deleted successfully.');
    });
  } catch (e) {
    print('Failed to delete user: $e');
  }
}
