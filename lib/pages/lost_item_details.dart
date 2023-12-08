
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LostItemDetails extends StatelessWidget {
  final String documentId;

  const LostItemDetails({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost Item Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("lost_Items")
            .doc(documentId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              Map<String, dynamic>? data =
                  snapshot.data!.data() as Map<String, dynamic>?;

              if (data != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('Lost Item: $documentId'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Item Name: ${data['Item_Name']}'),
                          Text('Description: ${data['Description']}'),
                          Text('Location: ${data['Location']}'),
                          // Add more fields as needed
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Text('Document data is null');
              }
            } else {
              return const Text('Document does not exist');
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
