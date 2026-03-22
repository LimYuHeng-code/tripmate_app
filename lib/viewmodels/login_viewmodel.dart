import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn? _googleSignIn;

  bool isLoading = false;
  String? errorMessage;

  bool get isLoggedIn => _auth.currentUser != null;

  /// ----------------- SIGN UP -----------------
  Future<bool> signUp(String email, String password) async {
    _startLoading();
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      _stopLoading();
    }
  }

  /// ----------------- EMAIL LOGIN -----------------
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

  /// ----------------- RESET PASSWORD -----------------
  Future<void> resetPassword(String email) async {
    _startLoading();
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } finally {
      _stopLoading();
    }
  }

  /// ----------------- GOOGLE LOGIN -----------------
  void initGoogleSignIn({required String serverClientId}) {
    _googleSignIn = GoogleSignIn(serverClientId: serverClientId);
  }

  Future<void> trySilentSignIn() async {
    if (_googleSignIn == null) return;
    try {
      final googleUser = await _googleSignIn!.signInSilently();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        notifyListeners();
      }
    } catch (e) {
      print("Silent Google sign-in failed: $e");
    }
  }

  Future<void> signInWithGoogle() async {
    _startLoading();
    try {
      if (_googleSignIn == null) throw Exception('Call initGoogleSignIn first');

      GoogleSignInAccount? googleUser = await _googleSignIn!.signInSilently();
      googleUser ??= await _googleSignIn!.signIn();

      if (googleUser == null) {
        _stopLoading();
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Google sign-in failed: $e';
    } finally {
      if (isLoading) _stopLoading();
    }
  }

  /// ----------------- SIGN OUT -----------------
  Future<void> signOut() async {
    _startLoading();
    try {
      await _googleSignIn?.signOut();
      await _auth.signOut();
    } finally {
      _stopLoading();
    }
  }

  /// ----------------- LOADING -----------------
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