import 'package:flutter/cupertino.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Auth with ChangeNotifier {
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> resetRequest(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
