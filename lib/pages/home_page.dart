import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_items/pages/found_items.dart';
import 'package:lost_and_found_items/pages/home_content.dart';
import 'package:lost_and_found_items/pages/lost_item.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0;

  void _navigatorBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  final List<Widget> _pages = [
    HomeContent(),
    LostItemPage(),
    FoundItems(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Row(children: [
            IconButton(
              icon: const Icon(Icons.notification_important),
              onPressed: () {},
            ),
            Text(
              user.email!,
              style: TextStyle(fontSize: 10),
            ),
          ]),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 51, 49, 49),
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Align items at the top and bottom
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'lib/images/logo.png',
                      // color: Colors.amber,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Home",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => _navigatorBar(0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Lost Item",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => _navigatorBar(1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Found Items",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => _navigatorBar(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Setting",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => _navigatorBar(3),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 16.0),
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => {signUserOut()},
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
