import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_items/pages/lost_items/lost_item_details.dart';

class GetLostItem extends StatelessWidget {
  final String documentId;

  GetLostItem({
    Key? key,
    required this.documentId,
  }) : super(key: key);

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
        FirebaseFirestore.instance.collection("lost_Items").doc(documentId);

    return FutureBuilder<DocumentSnapshot>(
      future: documentReference.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic>? data =
                snapshot.data!.data() as Map<String, dynamic>?;

            if (data != null) {
              return GestureDetector(
                onTap: () => navigateToLostItemDetails(context),
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
            } else {
              return const Text('Document data is null');
            }
          } else {
            return const Text('Document does not exist');
          }
        }
        return const Text('Loading ...');
      },
    );
  }
}
