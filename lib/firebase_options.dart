// File generated from google-services.json
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
    apiKey: 'AIzaSyC6b7UnBD3t7iSuX6_HJQsWj-xhrFoSeFU',
    appId: '1:120120911478:web:placeholder',
    messagingSenderId: '120120911478',
    projectId: 'animigo-b899d',
    authDomain: 'animigo-b899d.firebaseapp.com',
    storageBucket: 'animigo-b899d.firebasestorage.app',
    databaseURL: 'https://animigo-b899d-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6b7UnBD3t7iSuX6_HJQsWj-xhrFoSeFU',
    appId: '1:120120911478:android:05df6dac1cdd0a89c4e157',
    messagingSenderId: '120120911478',
    projectId: 'animigo-b899d',
    storageBucket: 'animigo-b899d.firebasestorage.app',
    databaseURL: 'https://animigo-b899d-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC6b7UnBD3t7iSuX6_HJQsWj-xhrFoSeFU',
    appId: '1:120120911478:ios:placeholder',
    messagingSenderId: '120120911478',
    projectId: 'animigo-b899d',
    storageBucket: 'animigo-b899d.firebasestorage.app',
    databaseURL: 'https://animigo-b899d-default-rtdb.firebaseio.com',
    iosBundleId: 'com.rk.Animigo',
  );
}
