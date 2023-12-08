import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_items/pages/view_lost_item.dart';

class LostItemPage extends StatefulWidget {
  LostItemPage({Key? key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  State<LostItemPage> createState() => _LostItemPageState();
}

class _LostItemPageState extends State<LostItemPage> {
  // Text controllers
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    _itemNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future addItemDetail(BuildContext context) async {
    try {
      // Capture the context
      BuildContext dialogContext = context;

      // Show a loading indicator
      showDialog(
        context: dialogContext,
        builder: (context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Submitting...'),
              ],
            ),
          );
        },
      );

      // Add item detail
      await FirebaseFirestore.instance.collection('lost_Items').add({
        'email': widget.user.email,
        'Item_Name': _itemNameController.text.trim(),
        'Description': _descriptionController.text.trim(),
        'Location': _locationController.text.trim(),
      });

      // Close the loading indicator
      // ignore: use_build_context_synchronously
      Navigator.pop(dialogContext);

      // Navigate to another page after successful submission
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ViewLostItem(),
        ),
      );
    } catch (e) {
      // Handle the error, e.g., show an error message to the user
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Close the loading indicator if an error occurs
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit item. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Lost Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lost Item Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _itemNameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                  labelText: 'Location where it was lost'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await addItemDetail(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
