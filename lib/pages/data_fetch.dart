import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataFetcher {
  static Future<List<String>> getDocIds() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("lost_Items").get();
      return snapshot.docs.map((document) => document.id).toList();
    } catch (e) {
      // Handle any potential errors here
      print("Error fetching docIds: $e");
      return [];
    }
  }
}

