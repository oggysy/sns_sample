import 'package:firebase_auth/firebase_auth.dart';

class Authenticator {
  const Authenticator();
  static String? get userId => FirebaseAuth.instance.currentUser?.uid;
}
