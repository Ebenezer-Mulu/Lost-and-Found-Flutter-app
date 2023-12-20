import 'package:flutter/material.dart';
import 'package:lost_and_found_items/pages/lost_items/lost_item.dart';
import 'package:lost_and_found_items/pages/lost_items/view_lost_item.dart';

import '../../components/bottomnavbar.dart';

class LostHomePage extends StatefulWidget {
  LostHomePage({Key? key}) : super(key: key);

  @override
  State<LostHomePage> createState() => _LostHomePageState();
}

class _LostHomePageState extends State<LostHomePage> {
  int _selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  void _navigatorBar(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<Widget> _pages = [
    LostItemPage(),
    const ViewLostItem(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: BottomNavBar(
          onTabChange: _navigatorBar, selectedIndex: _selectedIndex),
      body: _pages[_selectedIndex],
    );
  }
}
