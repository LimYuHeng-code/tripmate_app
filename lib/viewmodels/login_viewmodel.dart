import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/login_user_model.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginUser? currentUser;
  bool isLoading = false;
  String? errorMessage;

  // ===== Email/Password login =====
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

  // ===== Anonymous login =====
  Future<void> signInAnonymously() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final credential = await _auth.signInAnonymously();
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

  // ===== Optional: Sign out =====
  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }
}
