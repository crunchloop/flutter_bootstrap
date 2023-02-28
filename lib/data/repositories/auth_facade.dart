import 'package:auth/auth.dart';
import 'package:injectable/injectable.dart';

import '../models/user.dart';

@Injectable()
class AuthFacade {
  Future<void> signIn({
    required String email,
    required String password,
  }) {
    return Auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register(
      {required String username,
      required String email,
      required String password}) {
    return Auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  User? getUser() {
    final user = Auth.currentUser;

    return user == null
        ? null
        : User(id: user.uid, email: user.email, username: user.displayName);
  }

  Future<void> signOut() {
    return Auth.signOut();
  }
}
