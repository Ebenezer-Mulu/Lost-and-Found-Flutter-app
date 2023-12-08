import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_items/read_data/get_find_items.dart';

class ViewFoundItem extends StatefulWidget {
  ViewFoundItem({super.key});

  @override
  State<ViewFoundItem> createState() => _ViewFoundItemState();
}

class _ViewFoundItemState extends State<ViewFoundItem> {
//document IDs
  List<String> docIds = [];

  //get docIds
  Future getDocId() async {
    await FirebaseFirestore.instance.collection("find_Items").get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              docIds.add(document.reference.id);
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: getDocId(),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: docIds.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: GetFoundItem(documentId: docIds[index]),
                      tileColor: Colors.grey[300],
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    ));
  }
}
