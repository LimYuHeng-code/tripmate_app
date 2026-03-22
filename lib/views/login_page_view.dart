import 'package:flutter/material.dart';
import '../viewmodels/login_viewmodel.dart';
import 'signup_page_view.dart';
import 'home_page_view.dart';
import 'resetpassword_view.dart'; // <-- import the new page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginViewModel _viewModel;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();
    _viewModel.addListener(_onStateChanged);

    // Initialize Google Sign-In if needed
    _viewModel.initGoogleSignIn(
      serverClientId:
          "663903782058-8gdk4rdi3uelfqcbcioupntb6cbbotj9.apps.googleusercontent.com",
    );
    _viewModel.trySilentSignIn(); // Sign in silently on load
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onStateChanged);
    _viewModel.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (_viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_viewModel.errorMessage!)));
    }

    // Navigate if login successful
    if (_viewModel.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    }
  }

  Future<void> _signInEmail() async {
    FocusScope.of(context).unfocus();
    await _viewModel.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  Future<void> _signInGoogle() async {
    FocusScope.of(context).unfocus();
    await _viewModel.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.25;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // App title
                Text(
                  'Trip Mate',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'where the travel begins',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Travel image placeholder
                Container(
                  height: imageHeight,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withOpacity(0.35),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/travel.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 40),

                // Email field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Password field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),

                // Forgot password button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _viewModel.isLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResetPasswordPage(viewModel: _viewModel),
                              ),
                            );
                          },
                    child: const Text("Forgot password?"),
                  ),
                ),
                const SizedBox(height: 16),

                // Sign in with Email
                AnimatedBuilder(
                  animation: _viewModel,
                  builder: (_, __) {
                    return ElevatedButton(
                      onPressed: _viewModel.isLoading ? null : _signInEmail,
                      child: _viewModel.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign in with Email'),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Google Sign-In
                AnimatedBuilder(
                  animation: _viewModel,
                  builder: (_, __) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _viewModel.isLoading ? null : _signInGoogle,
                      child: _viewModel.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/google-icon.png',
                                  height: 18,
                                  width: 18,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Sign in with Google',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignUpPage()),
                              );
                            },
                      child: const Text("Sign up"),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}