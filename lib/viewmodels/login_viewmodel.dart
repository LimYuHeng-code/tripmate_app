import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/login_user_model.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginUser? currentUser;
  bool isLoading = false;
  String? errorMessage;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      currentUser = LoginUser.fromFirebase(credential.user);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Something went wrong';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool get isLoggedIn => currentUser != null;
}
