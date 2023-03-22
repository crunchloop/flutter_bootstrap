library firebase_initialization;

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

class FirebaseInitialization {
  static Future<FirebaseApp> initialize() async {
    return await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
}
