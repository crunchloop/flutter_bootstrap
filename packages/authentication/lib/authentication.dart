import 'data/models/user.dart';

abstract class Authentication {
  User? getUser() {
    return null;
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {}

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {}

  Future<void> signOut() async {}
}
