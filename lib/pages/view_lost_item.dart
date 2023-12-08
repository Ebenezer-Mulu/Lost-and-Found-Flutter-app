import 'dart:async';
import 'package:flutter/material.dart';
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
    docIds = await DataFetcher.getDocIds();
    _filteredDocIdsController.add(docIds);
  }

  void searchItem() {
    setState(() {
      search = _searchController.text.trim();
    });

    List<String> filteredDocIds = docIds.where((docId) {
      String itemName = docId;
      return itemName.toLowerCase().contains(search.toLowerCase());
    }).toList();

    _filteredDocIdsController.add(filteredDocIds);
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
              padding: const EdgeInsets.only(top: 40.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 75, 54, 54)),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 20),
                          hintText: 'Search',
                          hintStyle:
                              TextStyle(color: Color.fromARGB(255, 75, 54, 54)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: searchItem,
                      child: const Icon(Icons.search, color: Colors.grey),
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
                final filteredDocIds = snapshot.data ?? docIds;
                return ListView.builder(
                  itemCount: filteredDocIds.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: GetLostItem(documentId: filteredDocIds[index]),
                        tileColor: Colors.grey[300],
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
