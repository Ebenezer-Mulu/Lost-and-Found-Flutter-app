import 'package:flutter/material.dart';

class ListTiles extends StatelessWidget {
  final IconData icon;
  final String text;
  void Function()? onTap;

  ListTiles(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      onTap: onTap,
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
