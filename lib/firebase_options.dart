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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // 🎯 ویب کیلیے فائر بیس کنفیگریشن
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDuo41m3PSRaj0xk4RSuidvjpChTjoM7Qw',
    appId: '1:559470553711:web:1434ea9e05cc073c633b9a',
    messagingSenderId: '559470553711',
    projectId: 'nayab-qist-point',
    authDomain: 'nayab-qist-point.firebaseapp.com',
    storageBucket: 'nayab-qist-point.firebasestorage.app',
    measurementId: 'G-33TSZN62T6',
  );

  // 🎯 اینڈرائیڈ کیلیے فائر بیس کنفیگریشن
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfAz5FS2XB4E9Slch3QWF66G3MXlPsLAM',
    appId: '1:559470553711:android:282b047a586f6249633b9a',
    messagingSenderId: '559470553711',
    projectId: 'nayab-qist-point',
    storageBucket: 'nayab-qist-point.firebasestorage.app',
  );
}