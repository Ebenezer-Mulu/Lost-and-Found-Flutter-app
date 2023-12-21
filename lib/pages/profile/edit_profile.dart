import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_items/components/text_box.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final usersCollection = FirebaseFirestore.instance.collection('user');

  Future<void> editField(String field) async {
    String? newValue;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Update in Firestore
              if (newValue != null && newValue!.trim().isNotEmpty) {
                await updateUserField(field, newValue!);
                // Rebuild the widget to reflect the changes
                setState(() {});
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> updateUserField(String field, String value) async {
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(currentUser?.uid)
          .update({field: value});
    } catch (e) {
      print("Error updating user $field: $e");
      // Handle the error appropriately.
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("user")
          .doc(currentUser?.uid)
          .get();

      if (snapshot.exists) {
        return snapshot;
      } else {
        print("User document does not exist for UID: ${currentUser?.uid}");
        return snapshot;
      }
    } catch (e) {
      print("Error fetching user details: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            Map<String, dynamic>? user =
                snapshot.data?.data() as Map<String, dynamic>?;

            if (user != null) {
              return ListView(
                children: [
                  const SizedBox(height: 50),
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),
                  Text(
                    user['email'] ?? 'No email',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Details',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  TextBoxs(
                    text: user['email'],
                    sectionName: "Email",
                    onPressed: () => editField('email'),
                  ),
                  TextBoxs(
                    text: user['username'],
                    sectionName: "Username",
                    onPressed: () => editField('username'),
                  )
                ],
              );
            } else {
              return const Text('User data is null');
            }
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }
}
