import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // Create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print('Title : ${message.notification!.title}');
      print('Body : ${message.notification!.body}');
    }
    print('Payload : ${message.data}');
  }

  // Function to initialize notifications
  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();

      // Fetch token
      final fCMToken = await _firebaseMessaging.getToken();

      // Print token if not null
      if (fCMToken != null) {
        print("Token: $fCMToken");
      } else {
        print("Firebase Cloud Messaging token is null.");
      }
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  // Function to handle received messages

  // Function to initialize foreground and background settings
}
