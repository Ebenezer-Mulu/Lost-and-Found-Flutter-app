import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_and_found_items/pages/view_found_item.dart';

class FoundItems extends StatefulWidget {
  FoundItems({super.key});
  final user = FirebaseAuth.instance.currentUser!;

  @override
  State<FoundItems> createState() => _FoundItemsState();
}

class _FoundItemsState extends State<FoundItems> {
  final TextEditingController _ItemNameController = TextEditingController();
  final TextEditingController _DescriptionController = TextEditingController();
  final TextEditingController _LocationController = TextEditingController();

  String imageUrl = "";

  void imagePicker() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // upload to Firebase
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    // create a reference for the image
    Reference referenceImageToupload = referenceDirImages.child(uniqueFileName);

    // store the file
    try {
      await referenceImageToupload.putFile(File(file.path));
      imageUrl = await referenceImageToupload.getDownloadURL();
      print(imageUrl);
    } catch (e) {
      print('Error uploading image: $e');
    }
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
      await FirebaseFirestore.instance.collection('find_Items').add({
        'email': widget.user.email,
        'item_Name': _ItemNameController.text.trim(),
        'description': _DescriptionController.text.trim(),
        'location': _LocationController.text.trim(),
        'image': imageUrl,
      });

      // Close the loading indicator
      Navigator.pop(dialogContext);

      // Navigate to another page after successful submission
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ViewFoundItem(),
        ),
      );
    } catch (e) {
      print('Error adding item: $e');
      // Handle the error, e.g., show an error message to the user
      Navigator.pop(context); // Close the loading indicator if an error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit item. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Found Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _ItemNameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _DescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _LocationController,
                decoration: const InputDecoration(labelText: 'Location'),
                maxLines: 3,
              ),
              IconButton(
                onPressed: imagePicker,
                icon: Icon(Icons.camera_alt),
              ),
              ElevatedButton(
                onPressed: () async {
                  await addItemDetail(context);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
