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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCL9YKxDrz2bfgVgn2vuDVwIjkSnljOFBs',
    appId: '1:647725682472:web:1777b070fa6f2d7ccc8a1d',
    messagingSenderId: '647725682472',
    projectId: 'reminder-app-803e2',
    authDomain: 'reminder-app-803e2.firebaseapp.com',
    storageBucket: 'reminder-app-803e2.appspot.com',
    measurementId: 'G-L2P2GE75CR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBPr-ftQj73OtJif1-9Qi5o5XR2TVjq4Z4',
    appId: '1:647725682472:android:d1787d29aa4e5594cc8a1d',
    messagingSenderId: '647725682472',
    projectId: 'reminder-app-803e2',
    storageBucket: 'reminder-app-803e2.appspot.com',
  );
}
