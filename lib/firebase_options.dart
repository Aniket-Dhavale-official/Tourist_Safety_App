import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDyR4hthZ4sHaRFzvAbQfYn1Z7lx-PH0RE',
    appId: '1:153073705237:web:placeholder', // TODO: Replace with your Web App ID from Firebase Console
    messagingSenderId: '153073705237',
    projectId: 'tourist-safety-141801',
    authDomain: 'tourist-safety-141801.firebaseapp.com',
    storageBucket: 'tourist-safety-141801.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyR4hthZ4sHaRFzvAbQfYn1Z7lx-PH0RE',
    appId: '1:153073705237:android:60e77a4e01507c8f6b491c',
    messagingSenderId: '153073705237',
    projectId: 'tourist-safety-141801',
    storageBucket: 'tourist-safety-141801.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyR4hthZ4sHaRFzvAbQfYn1Z7lx-PH0RE',
    appId: '1:153073705237:ios:placeholder', // TODO: Replace with your iOS App ID if needed
    messagingSenderId: '153073705237',
    projectId: 'tourist-safety-141801',
    storageBucket: 'tourist-safety-141801.firebasestorage.app',
    iosBundleId: 'com.example.tourist_safety_new',
  );
}
