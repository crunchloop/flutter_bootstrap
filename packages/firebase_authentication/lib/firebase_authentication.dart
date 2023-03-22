library firebase_auth;

import 'package:authentication/authentication.dart';
import 'package:authentication/data/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:logger/logger.dart';

class FirebaseAuthentication implements Authentication {
  FirebaseAuthentication._(instance) : _firebaseAuth = instance;

  final fb.FirebaseAuth _firebaseAuth;

  static final _instance = FirebaseAuthentication._(fb.FirebaseAuth.instance);
  static FirebaseAuthentication get instance => _instance;

  @override
  User? getUser() {
    final user = _firebaseAuth.currentUser;

    return user == null
        ? null
        : User(id: user.uid, email: user.email, username: user.displayName);
  }

  @override
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on fb.FirebaseAuthException catch (e) {
      Logger logger = Logger();
      logger.e(e);
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
