import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Ensures the user is authenticated (anonymous if not signed in)
  Future<void> ensureAnonymousAuth() async {
    if (_auth.currentUser == null) {
      try {
        await _auth.signInAnonymously();
        print('✅ Signed in anonymously as ${_auth.currentUser!.uid}');
      } catch (e) {
        print('❌ Anonymous sign-in failed: $e');
        rethrow;
      }
    } else {
      print('ℹ️ Already signed in as ${_auth.currentUser!.uid}');
    }
  }

  User? get currentUser => _auth.currentUser;
}
