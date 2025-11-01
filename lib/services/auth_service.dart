import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );


    await cred.user!.updateDisplayName(username);


    await cred.user!.sendEmailVerification();

    return cred;
  }


  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred;
  }


  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }


  Future<void> resendVerificationEmail(User user) async {
    await user.sendEmailVerification();
  }


  Future<void> logout() async {
    await _auth.signOut();
  }
}
