// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAoJDScDBswQ4HddVtSZ42kZYU1Mv0xURo',
    appId: '1:554443647221:web:8be845812940bdd626fdbc',
    messagingSenderId: '554443647221',
    projectId: 'lost-and-found-6da1d',
    authDomain: 'lost-and-found-6da1d.firebaseapp.com',
    storageBucket: 'lost-and-found-6da1d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCOuQZ09XbMwdjJzbbKeBltq8Vop-9l6QA',
    appId: '1:554443647221:android:774106a2f579d3e726fdbc',
    messagingSenderId: '554443647221',
    projectId: 'lost-and-found-6da1d',
    storageBucket: 'lost-and-found-6da1d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzXSFlkq3TDevodAqVeQ4J6JD6WL6YFMQ',
    appId: '1:554443647221:ios:855fb58a52a27c2626fdbc',
    messagingSenderId: '554443647221',
    projectId: 'lost-and-found-6da1d',
    storageBucket: 'lost-and-found-6da1d.appspot.com',
    androidClientId: '554443647221-6ln5sueg4skuq3p9vtmcq9bu22gg9b8o.apps.googleusercontent.com',
    iosClientId: '554443647221-qt87heaeqgmkufcubb2mtpq4m5lbork9.apps.googleusercontent.com',
    iosBundleId: 'com.example.lostAndFoundItems',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCzXSFlkq3TDevodAqVeQ4J6JD6WL6YFMQ',
    appId: '1:554443647221:ios:57325b384fcbc14126fdbc',
    messagingSenderId: '554443647221',
    projectId: 'lost-and-found-6da1d',
    storageBucket: 'lost-and-found-6da1d.appspot.com',
    androidClientId: '554443647221-6ln5sueg4skuq3p9vtmcq9bu22gg9b8o.apps.googleusercontent.com',
    iosClientId: '554443647221-3bvnpebimt7fjsrnn1ft4m997i6bpml1.apps.googleusercontent.com',
    iosBundleId: 'com.example.lostAndFoundItems.RunnerTests',
  );
}
