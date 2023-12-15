import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/text_box.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser!;

  // edit field
  Future<void> editField(String field) async {
    // Add your logic to edit the specified field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(color: Colors.grey[900]),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(user.email)
            .snapshots(),
        builder: (context, snapshot) {
          print("Connection State: ${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            print("aa");
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            print("bb");
            print("User email: ${user.email}");
            print("af");
            print("User Data: $userData");

            // Add additional debug prints here to isolate the issue
            print("Username from userData: ${userData["username"]}");

            return ListView(
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.person,
                  size: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  user.email ?? "No Email",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    "My Details",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                TextBoxs(
                  text: userData["username"] ?? "No Username",
                  sectionName: "username",
                  onPressed: () => editField('username'),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            // Handle the waiting state
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error fetching data: ${snapshot.error}');
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
