import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:lost_and_found_items/pages/data_fetch.dart';
import 'package:lost_and_found_items/pages/lost_items/view_lost_item.dart';
import 'package:lost_and_found_items/read_data/get_lost_items.dart';

import '../components/button.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Find Retrieve Discover Reclaim Reassure ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 250,
              child: FutureBuilder<List<String>>(
                future: DataFetcher.getDocIds(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<String> documentIds = snapshot.data!;
                      return ScrollSnapList(
                        itemBuilder: (context, index) {
                          String documentId = documentIds[index];
                          return _buildListItem(context, documentId);
                        },
                        itemCount: documentIds.length,
                        itemSize: 150,
                        onItemFocus: (int index) {
                          // Handle item focus
                        },
                        dynamicItemSize: true,
                        scrollDirection: Axis.horizontal,
                      );
                    } else {
                      return const Text('No data available');
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const SizedBox(height: 25),
            Button(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewLostItem()),
                );
              },
              text: "See More",
            ),
            const SizedBox(height: 8), // Adjust the spacing as needed
            Text(
              "Your quick and easy solution for reporting and recovering lost items.",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String documentId) {
    return SizedBox(
      width: 150,
      height: 300,
      child: Card(
        elevation: 12,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Column(
            children: [
              GetLostItem(
                  documentId:
                      documentId), // Assuming you have GetLostItem widget
              // You can add more content here based on your design
            ],
          ),
        ),
      ),
    );
  }
}
