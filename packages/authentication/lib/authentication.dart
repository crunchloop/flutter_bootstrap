abstract class Authentication {
  Future<void> signInWithEmailAndPassword(
    {required String email, required String password}) async {}

  Future<void> createUserWithEmailAndPassword(
    {required String email, required String password}) async {}

  Future<void> signOut() async {}
}
