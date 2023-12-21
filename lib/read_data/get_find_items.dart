import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/lost_items/lost_item_details.dart';

class GetFoundItem extends StatelessWidget {
  final String documentId;

  GetFoundItem({Key? key, required this.documentId}) : super(key: key);

  void navigateToLostItemDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LostItemDetails(documentId: documentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("find_Items").doc(documentId);

    return FutureBuilder<DocumentSnapshot>(
      future: documentReference.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Error state
          return Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Document does not exist
          return Center(child: Text('Document does not exist'));
        }

        // Data loaded successfully
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        return GestureDetector(
          onTap: () => navigateToLostItemDetails(context),
          child: SizedBox(
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
          ),
        );
      },
    );
  }
}