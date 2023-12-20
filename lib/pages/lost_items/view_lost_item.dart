import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_and_found_items/pages/data_fetch.dart';
import 'package:lost_and_found_items/read_data/get_lost_items.dart';

class ViewLostItem extends StatefulWidget {
  const ViewLostItem({Key? key}) : super(key: key);

  @override
  State<ViewLostItem> createState() => _ViewLostItemState();
}

class _ViewLostItemState extends State<ViewLostItem> {
  String search = "";
  late List<String> docIds;
  final TextEditingController _searchController = TextEditingController();
  late StreamController<List<String>> _filteredDocIdsController;

  @override
  void initState() {
    super.initState();
    docIds = [];
    _filteredDocIdsController = StreamController<List<String>>.broadcast();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      docIds = await DataFetcher.getDocIds();
      _filteredDocIdsController.add(docIds);
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  void searchItem() async {
    setState(() {
      search = _searchController.text.trim();
    });

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('lost_Items')
          .where('Item_Name', isGreaterThanOrEqualTo: search)
          .where('Item_Name',
              isLessThan: search + 'z') // assuming Item_Name is a string field
          .get();

      List<DocumentSnapshot> documents = querySnapshot.docs;

      List<String> filteredDocIds = documents.map((doc) {
        // Assuming you want to use a specific field as the identifier
        return doc.id; // or doc['fieldName']
      }).toList();

      _filteredDocIdsController.add(filteredDocIds);
    } catch (e) {
      // Handle the error
      print('Error searching items: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredDocIdsController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 80.0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                padding: const EdgeInsets.only(left: 25),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GestureDetector(
                        onTap: searchItem,
                        child: const Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: StreamBuilder<List<String>>(
              stream: _filteredDocIdsController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final filteredDocIds = snapshot.data ?? docIds;
                return ListView.builder(
                  itemCount: filteredDocIds.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: GetLostItem(documentId: filteredDocIds[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
