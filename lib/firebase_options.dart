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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDYTcR-T2JsS3WExFQ6Be8aqn-_Lpk6VKM',
    appId: '1:40070251536:web:ba18fa2bb5c747ae9cb695',
    messagingSenderId: '40070251536',
    projectId: 'huumirameningredient-1b53f',
    authDomain: 'huumirameningredient-1b53f.firebaseapp.com',
    storageBucket: 'huumirameningredient-1b53f.appspot.com',
    measurementId: 'G-WLL3QW321X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA3QcL5IMIqvxqbm8FgbDejqP1pM31jh3Y',
    appId: '1:40070251536:android:0699af846e0d866e9cb695',
    messagingSenderId: '40070251536',
    projectId: 'huumirameningredient-1b53f',
    storageBucket: 'huumirameningredient-1b53f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYT70R5mic7uxmdHAap6y0-pnIBbmpXRY',
    appId: '1:40070251536:ios:53318e5be6b457ee9cb695',
    messagingSenderId: '40070251536',
    projectId: 'huumirameningredient-1b53f',
    storageBucket: 'huumirameningredient-1b53f.appspot.com',
    iosClientId: '40070251536-11n88brql118ibq8a1vldbjtihr519bb.apps.googleusercontent.com',
    iosBundleId: 'com.example.huumirameningr',
  );
}
