import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  FirebaseAuth auth=FirebaseAuth.instance;
  AuthServices(this.auth);
}