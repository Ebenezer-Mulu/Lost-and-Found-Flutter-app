import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_and_found_items/components/Text_form.dart';
import 'package:lost_and_found_items/pages/found_items/view_found_item.dart';

import '../../components/button.dart';

class FoundItems extends StatefulWidget {
  FoundItems({super.key});
  final user = FirebaseAuth.instance.currentUser!;

  @override
  State<FoundItems> createState() => _FoundItemsState();
}

class _FoundItemsState extends State<FoundItems> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime _dateTime = DateTime.now();

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

  void _showDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
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
        'item_Name': _itemNameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'Date': _dateTime.toString().trim(),
        'image': imageUrl,
      });

      // Close the loading indicator
      Navigator.pop(dialogContext);

      _itemNameController.clear();
      _descriptionController.clear();
      _locationController.clear();
    } catch (e) {

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              "Fill the Form",
              style: TextStyle(fontSize: 40, color: Colors.grey.shade600),
            )),
            const SizedBox(height: 30),
            TextForm(
              text: 'Item Name',
              controller: _itemNameController,
              hintText: 'Enter the item name',
              iconData: Icons.shopping_bag,
              maxLines: 1,
              onPressed: () {
                _itemNameController.clear();
              },
            ),
            const SizedBox(height: 16),
            TextForm(
              text: 'Description',
              controller: _descriptionController,
              hintText: 'Enter a description',
              iconData: Icons.description,
              maxLines: 3,
              onPressed: () {
                _descriptionController.clear();
              },
            ),
            const SizedBox(height: 16),
            TextForm(
              text: 'Enter the location',
              controller: _locationController,
              hintText: "Location where it was lost",
              iconData: Icons.location_on,
              maxLines: 1,
              onPressed: () {
                _locationController.clear();
              },
            ),
            const SizedBox(height: 16),
            IconButton(
              onPressed: imagePicker,
              icon: const Icon(Icons.camera_alt),
            ),
            MaterialButton(
              onPressed: _showDatePicker,
              child: const Text("Date Picker"),
            ),
            Button(
                onTap: () async {
                  await addItemDetail(context);
                },
                text: 'Submit'),
          ],
        ),
      ),
    );
  }
}
