import 'package:auth/auth.dart';

class FirebaseAuthService {
  static Future<FirebaseAuthService> init() async {
    await Auth.initialize();

    return FirebaseAuthService();
  }
}
