import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String? errorMessage;

  bool get isLoggedIn => _auth.currentUser != null;

  /// Initialize GoogleSignIn (call once)
  Future<void> initGoogleSignIn({
    required String androidClientId,
  }) async {
    try {
      await GoogleSignIn.instance.initialize(
        clientId: androidClientId,
        serverClientId: androidClientId,
      );
    } catch (e) {
      errorMessage = "Google SignIn init failed: $e";
      notifyListeners();
    }
  }

  // ---------------- EMAIL LOGIN ----------------
  Future<void> signInWithEmail(String email, String password) async {
    _startLoading();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } finally {
      _stopLoading();
    }
  }

  // ---------------- ANONYMOUS ----------------
  Future<void> signInAnonymously() async {
    _startLoading();
    try {
      await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? 'Guest sign-in failed';
    } finally {
      _stopLoading();
    }
  }

  // ---------------- GOOGLE SIGN-IN ----------------
  Future<void> signInWithGoogle() async {
    _startLoading();
    try {
      // Authenticate the user
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn.instance.authenticate(
        scopeHint: ['email'],
      );

      if (googleUser == null) {
        // User canceled
        return;
      }

      // Firebase credential
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Google sign-in failed: $e';
    } finally {
      _stopLoading();
    }
  }

  Future<void> signOut() async {
    _startLoading();
    try {
      await _auth.signOut();
      await GoogleSignIn.instance.signOut();
    } finally {
      _stopLoading();
    }
  }

  void _startLoading() {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
  }

  void _stopLoading() {
    isLoading = false;
    notifyListeners();
  }
}

