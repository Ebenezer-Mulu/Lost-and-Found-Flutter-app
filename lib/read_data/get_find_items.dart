import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetFoundItem extends StatelessWidget {
  final String documentId;

  GetFoundItem({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get reference to the document
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("lost_Items").doc(documentId);

    return FutureBuilder<DocumentSnapshot>(
      future: documentReference.get(),
      builder: (context, snapshot) {
       

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic>? data =
                snapshot.data!.data() as Map<String, dynamic>?;

            if (data != null) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Text('Email: ${data['email']}'),
                    Text('Item Name: ${data['item_Name']}'),
                    Text('Description: ${data['description']}'),
                    Text('Location: ${data['location']}'),
                    if (data['image'] != null)
                      Image.network(
                        data['image'],
                        width: 100,
                        height: 100,
                      ),
                  ],
                ),
              );
            } else {
              return Text('Document does not exist');
            }
          } else {
            return Text('Document does not exist');
          }
        }
        return const Text('Loading ...');
      },
    );
  }
}
