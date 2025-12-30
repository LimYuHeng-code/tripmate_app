
class LoginUser {
  final String uid;
  final String email;

  LoginUser({
    required this.uid,
    required this.email,
  });

  factory LoginUser.fromFirebase(user) {
    return LoginUser(
      uid: user.uid,
      email: user.email ?? '',
    );
  }
}