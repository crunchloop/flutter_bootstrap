import 'package:authentication/authentication.dart';
import 'package:firebase_authentication/firebase_authentication.dart';
import 'package:injectable/injectable.dart';

import '../models/user.dart';

@Injectable()
class AuthRepository extends FirebaseAuthentication implements Authentication {
  User? getUser() {
    final user = super.currentUser;

    return user == null
        ? null
        : User(id: user.uid, email: user.email, username: user.displayName);
  }

  @override
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {

    return await super.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async  {

    return await super.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    return await super.signOut();
  }
}
