import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_items/components/list_tile.dart';
import 'package:lost_and_found_items/pages/found_items.dart';
import 'package:lost_and_found_items/pages/home_content.dart';
import 'package:lost_and_found_items/pages/lost_item.dart';
import 'package:lost_and_found_items/pages/profile.dart';
import 'package:lost_and_found_items/pages/users.dart';
import 'package:lost_and_found_items/pages/setting.dart';

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
    const Profile(),
    LostItemPage(),
    FoundItems(),
    Setting(),
    Users(),
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
                  child: ListTiles(
                    icon: Icons.home,
                    text: "Home",
                    onTap: () => _navigatorBar(0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTiles(
                    icon: Icons.person,
                    text: "Profile",
                    onTap: () => _navigatorBar(1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTiles(
                    icon: Icons.lock,
                    text: "Lost Item",
                    onTap: () => _navigatorBar(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTiles(
                    icon: Icons.lock,
                    text: "Found Item",
                    onTap: () => _navigatorBar(3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTiles(
                    icon: Icons.settings,
                    text: "Setting",
                    onTap: () => _navigatorBar(4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTiles(
                    icon: Icons.settings,
                    text: "Users",
                    onTap: () => _navigatorBar(5),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTiles(
                icon: Icons.logout,
                text: "Logout",
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
