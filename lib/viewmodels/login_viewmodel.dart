import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn? _googleSignIn;

  bool isLoading = false;
  String? errorMessage;

  bool get isLoggedIn => _auth.currentUser != null;

  /// Initialize GoogleSignIn.
  void initGoogleSignIn({
    // This is the Web client ID, needed for idToken on Android.
    required String serverClientId,
  }) {
    _googleSignIn = GoogleSignIn(
      serverClientId: serverClientId,
    );
  }

  /// Tries to sign in silently in the background on app start.
  Future<void> trySilentSignIn() async {
    if (_googleSignIn == null) {
      return;
    }
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signInSilently();

      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        notifyListeners(); // Notify listeners about login state change
      }
    } catch (e) {
      // Fail silently, the user will just see the login page.
      print("Silent sign-in failed: $e");
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
      if (_googleSignIn == null) {
        throw Exception('GoogleSignIn is not initialized. Call initGoogleSignIn first.');
      }

      // Try to sign in silently
      GoogleSignInAccount? googleUser = await _googleSignIn!.signInSilently();

      // If silent sign-in fails, fall back to interactive sign-in
      googleUser ??= await _googleSignIn!.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        _stopLoading();
        return;
      }

      // Firebase credential
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
      // Check isLoading, as _stopLoading() might have been called if user canceled.
      if (isLoading) {
        _stopLoading();
      }
    }
  }

  Future<void> signOut() async {
    _startLoading();
    try {
      await _googleSignIn?.signOut();
      await _auth.signOut();
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
