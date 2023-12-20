import 'package:flutter/material.dart';
import 'package:lost_and_found_items/pages/found_items/found_items.dart';
import '../../components/bottomnavbar.dart';
import 'view_found_item.dart';

class FoundHomePage extends StatefulWidget {
  const FoundHomePage({Key? key}) : super(key: key);

  @override
  State<FoundHomePage> createState() => _FounHomePageState();
}

class _FounHomePageState extends State<FoundHomePage> {
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
    FoundItems(),
    ViewFoundItem(),
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
