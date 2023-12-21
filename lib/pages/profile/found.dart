import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoundPost extends StatelessWidget {
  FoundPost({
    Key? key,
  }) : super(key: key);
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    CollectionReference findItemsCollection =
        FirebaseFirestore.instance.collection("find_Items");

    return FutureBuilder<QuerySnapshot>(
      future: findItemsCollection.where('email', isEqualTo: user!.email).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return Center(child: const CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Error state
          return Center(child: const Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Document does not exist
          return const Center(child: Text('Document does not exist'));
        }

        // Data loaded successfully
        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        return SingleChildScrollView(
          child: Column(
            children: documents.map((document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              return SizedBox(
                width: 300,
                child: Card(
                  child: ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data['image'] != null)
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(data['image']),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            const Text(
                              'Item Name:',
                              style: TextStyle(
                                fontSize: 18.0,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data['item_Name'],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Location:',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data['location'],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
