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
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: ''),
    appId: '1:570100756160:web:00f35f9aedb6dade448725',
    messagingSenderId: '570100756160',
    projectId: 'taskit-app-c9cf7',
    authDomain: 'taskit-app-c9cf7.firebaseapp.com',
    storageBucket: 'taskit-app-c9cf7.appspot.com',
    measurementId: 'G-XTGBTDV4J0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: ''),
    appId: '1:570100756160:android:778ba78996c4af0b448725',
    messagingSenderId: '570100756160',
    projectId: 'taskit-app-c9cf7',
    storageBucket: 'taskit-app-c9cf7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: ''),
    appId: '1:570100756160:ios:7bfab16136a2923f448725',
    messagingSenderId: '570100756160',
    projectId: 'taskit-app-c9cf7',
    storageBucket: 'taskit-app-c9cf7.appspot.com',
    iosClientId: '570100756160-nmtri487d8flphg2gd4ktcsvk7ugkp09.apps.googleusercontent.com',
    iosBundleId: 'com.example.taskitMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: ''),
    appId: '1:570100756160:ios:13d3f3b724002cae448725',
    messagingSenderId: '570100756160',
    projectId: 'taskit-app-c9cf7',
    storageBucket: 'taskit-app-c9cf7.appspot.com',
    iosClientId: '570100756160-pps3cql01jo9m52hrf9o6tpr5nbneq9g.apps.googleusercontent.com',
    iosBundleId: 'com.example.taskitMobile.RunnerTests',
  );
}