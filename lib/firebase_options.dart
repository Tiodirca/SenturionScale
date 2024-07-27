// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyC3e3gs1yGoyxUq-PMAJ28bnSk4DEPy3mI',
    appId: '1:776473338582:web:2c51326159a66e23cadf77',
    messagingSenderId: '776473338582',
    projectId: 'scalesenturionback',
    authDomain: 'scalesenturionback.firebaseapp.com',
    storageBucket: 'scalesenturionback.appspot.com',
    measurementId: 'G-0KRHF1LEBB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBq-zwkZLdFybyFfAnFvdlTTK5AoWCaq74',
    appId: '1:776473338582:android:b1dfb5387df28fa4cadf77',
    messagingSenderId: '776473338582',
    projectId: 'scalesenturionback',
    storageBucket: 'scalesenturionback.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCsnn9Yvl0G2GPlc-KW4Zk7IGMIP_c42sc',
    appId: '1:776473338582:ios:76b2f56f4041b356cadf77',
    messagingSenderId: '776473338582',
    projectId: 'scalesenturionback',
    storageBucket: 'scalesenturionback.appspot.com',
    iosBundleId: 'com.example.senturionscale',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCsnn9Yvl0G2GPlc-KW4Zk7IGMIP_c42sc',
    appId: '1:776473338582:ios:76b2f56f4041b356cadf77',
    messagingSenderId: '776473338582',
    projectId: 'scalesenturionback',
    storageBucket: 'scalesenturionback.appspot.com',
    iosBundleId: 'com.example.senturionscale',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC3e3gs1yGoyxUq-PMAJ28bnSk4DEPy3mI',
    appId: '1:776473338582:web:8566df35455ed263cadf77',
    messagingSenderId: '776473338582',
    projectId: 'scalesenturionback',

    authDomain: 'scalesenturionback.firebaseapp.com',
    storageBucket: 'scalesenturionback.appspot.com',
    measurementId: 'G-5W51577Z6T',
  );
}
