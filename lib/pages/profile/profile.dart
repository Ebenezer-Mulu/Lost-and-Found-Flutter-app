import 'package:flutter/material.dart';
import '../../components/bottomnavbar.dart';
import 'edit_profile.dart';
import 'found.dart';
import 'lost.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
    EditProfile(),
    LostPost(),
    FoundPost(),
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
