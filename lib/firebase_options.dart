import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDummyWebKeyForWizzyApp2026",
    appId: "1:10000000000:web:wizzy",
    messagingSenderId: "10000000000",
    projectId: "wizzy-dem",
    authDomain: "wizzy-dem.firebaseapp.com",
    storageBucket: "wizzy-dem.appspot.com",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDummyAndroidKeyForWizzyApp2026",
    appId: "1:10000000000:android:wizzy",
    messagingSenderId: "10000000000",
    projectId: "wizzy-dem",
    storageBucket: "wizzy-dem.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyDummyIosKeyForWizzyApp2026",
    appId: "1:10000000000:ios:wizzy",
    messagingSenderId: "10000000000",
    projectId: "wizzy-dem",
    storageBucket: "wizzy-dem.appspot.com",
    iosBundleId: "com.demproductions.wizzy",
  );
}
