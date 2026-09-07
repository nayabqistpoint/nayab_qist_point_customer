import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// 🚀 [DefaultFirebaseOptions] 
/// آپ کے فائر بیس پروجیکٹ 'nayab-qist-point' کی تمام کانفیگریشنز اس فائل میں شامل ہیں
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
          'DefaultFirebaseOptions Windows کے لیے کانفیگر نہیں ہیں۔',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions Linux کے لیے کانفیگر نہیں ہیں۔',
        );
      default:
        throw UnsupportedError(
          'یہ پلیٹ فارم سپورٹڈ نہیں ہے۔',
        );
    }
  }

  /// 🌐 Web Firebase Configuration (آپ کی نئی API Key کے ساتھ)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDUo41m3PSRaj0xk4RSuidvjpChTjoM7Qw',
    appId: '1:559470553711:web:1434ea9e05cc073c633b9a',
    messagingSenderId: '559470553711',
    projectId: 'nayab-qist-point',
    authDomain: 'nayab-qist-point.firebaseapp.com',
    storageBucket: 'nayab-qist-point.firebasestorage.app',
    measurementId: 'G-33TSZN62T6',
  );

  /// 🤖 Android Firebase Configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUo41m3PSRaj0xk4RSuidvjpChTjoM7Qw',
    appId: '1:559470553711:web:1434ea9e05cc073c633b9a',
    messagingSenderId: '559470553711',
    projectId: 'nayab-qist-point',
    storageBucket: 'nayab-qist-point.firebasestorage.app',
  );

  /// 🍎 iOS Firebase Configuration
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUo41m3PSRaj0xk4RSuidvjpChTjoM7Qw',
    appId: '1:559470553711:web:1434ea9e05cc073c633b9a',
    messagingSenderId: '559470553711',
    projectId: 'nayab-qist-point',
    storageBucket: 'nayab-qist-point.firebasestorage.app',
    iosBundleId: 'com.example.nayabQistPoint',
  );

  /// 💻 macOS Firebase Configuration
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDUo41m3PSRaj0xk4RSuidvjpChTjoM7Qw',
    appId: '1:559470553711:web:1434ea9e05cc073c633b9a',
    messagingSenderId: '559470553711',
    projectId: 'nayab-qist-point',
    storageBucket: 'nayab-qist-point.firebasestorage.app',
    iosBundleId: 'com.example.nayabQistPoint',
  );
}