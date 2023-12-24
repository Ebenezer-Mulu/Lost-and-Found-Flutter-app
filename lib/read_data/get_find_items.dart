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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Error state
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Document does not exist
          return const Center(child: Text('Document does not exist'));
        }

        // Data loaded successfully
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        return GestureDetector(
          onTap: () => navigateToLostItemDetails(context),
          child: SizedBox(
            width: 300,
            child: Card(
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'imageHero-$documentId',
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(data['image']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Item Name:',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data['item_Name'],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
