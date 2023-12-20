import 'package:flutter/material.dart';
import 'package:lost_and_found_items/components/button.dart';
import 'package:lost_and_found_items/pages/data_fetch.dart';
import 'package:lost_and_found_items/pages/lost_items/lost_item_details.dart';
import 'package:lost_and_found_items/pages/lost_items/view_lost_item.dart';
import 'package:lost_and_found_items/read_data/get_lost_items.dart';

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
              height: 150,
              child: FutureBuilder<List<String>>(
                future: DataFetcher.getDocIds(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          String documentId = snapshot.data![index];

                          // return GestureDetector(
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) =>
                          //             LostItemDetails(documentId: documentId),
                          //       ),
                          //     );
                          //   },
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       ListTile(
                          //         title: Text('Lost Item: $documentId'),
                          //         // Add more details here if needed
                          //       ),
                          //     ],
                          //   ),
                          // );
                        },
                      );
                    } else {
                      return const Text('No data available');
                    }
                  } else {
                    return const CircularProgressIndicator();
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
}
