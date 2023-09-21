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
    apiKey: 'AIzaSyDXqRNqlLCsoRHA8HNmumokRo7LJ2wM1Ic',
    appId: '1:197530779446:web:9683567cb37e8045d4fd97',
    messagingSenderId: '197530779446',
    projectId: 'shareit-v1',
    authDomain: 'shareit-v1.firebaseapp.com',
    databaseURL: 'https://shareit-v1-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'shareit-v1.appspot.com',
    measurementId: 'G-918Y55KDG6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDU9RiA26JWQdSvi11hclVFjsgaOLB8AvE',
    appId: '1:197530779446:android:bce0f5c8a19c7fabd4fd97',
    messagingSenderId: '197530779446',
    projectId: 'shareit-v1',
    databaseURL: 'https://shareit-v1-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'shareit-v1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-MDa9icyKn3KoD4REo7_N_QcJ3dvHSK4',
    appId: '1:197530779446:ios:ccb838937c89cc07d4fd97',
    messagingSenderId: '197530779446',
    projectId: 'shareit-v1',
    databaseURL: 'https://shareit-v1-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'shareit-v1.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC-MDa9icyKn3KoD4REo7_N_QcJ3dvHSK4',
    appId: '1:197530779446:ios:b63174c9163a418bd4fd97',
    messagingSenderId: '197530779446',
    projectId: 'shareit-v1',
    databaseURL: 'https://shareit-v1-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'shareit-v1.appspot.com',
    iosBundleId: 'com.example.flutterApplication1.RunnerTests',
  );
}