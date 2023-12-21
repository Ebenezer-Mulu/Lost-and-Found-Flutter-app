import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LostPost extends StatelessWidget {
  LostPost({
    Key? key,
  }) : super(key: key);

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    CollectionReference lostItemsCollection =
        FirebaseFirestore.instance.collection("lost_Items");

    return FutureBuilder<QuerySnapshot>(
      future: lostItemsCollection.where('email', isEqualTo: user!.email).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            QuerySnapshot querySnapshot = snapshot.data!;
            if (querySnapshot.docs.isNotEmpty) {
              return Column(
                children: querySnapshot.docs.map((QueryDocumentSnapshot doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;

                  return Center(
                    child: SizedBox(
                      width: 300,
                      child: Card(
                        child: ListTile(
                          subtitle: Column(
                          
                            crossAxisAlignment: CrossAxisAlignment.start,
                            
                            children: [
                              Text('Item Name: ${data['Item_Name']}'),
                              Text('Description: ${data['Description']}'),
                              Text('Location: ${data['Location']}'),
                              Text('Date: ${data['Date']}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              return const Text('Document does not exist');
            }
          }
        }
        return const Text('Loading ...');
      },
    );
  }
}
