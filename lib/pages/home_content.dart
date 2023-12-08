import 'package:flutter/material.dart';
import 'package:lost_and_found_items/components/button.dart';
import 'package:lost_and_found_items/pages/data_fetch.dart';
import 'package:lost_and_found_items/pages/view_lost_item.dart';
import 'package:lost_and_found_items/read_data/get_lost_items.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Welcome + Name",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  "Discover Peace of Mind with our Lost and Found app ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            FutureBuilder<List<String>>(
              future: DataFetcher.getDocIds(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child:
                            // GetLostItem(documentId: snapshot.data![index]),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text('No data available');
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
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
            const Text(
              "Your quick and easy solution for reporting and recovering lost items.",
            ),
          ],
        ),
      ),
    );
  }
}
