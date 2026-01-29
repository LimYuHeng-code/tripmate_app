import 'package:flutter/material.dart';
import '../viewmodels/login_viewmodel.dart';
import 'home_page_view.dart';

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preload travel image
    precacheImage(const AssetImage('assets/travel.png'), context);
    precacheImage(const AssetImage('assets/google-logo.png'), context);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInEmail() async {
    FocusScope.of(context).unfocus();
    await _viewModel.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    _navigateIfLoggedIn();
  }

  Future<void> _signInAnonymously() async {
    FocusScope.of(context).unfocus();
    await _viewModel.signInAnonymously();
    _navigateIfLoggedIn();
  }

  Future<void> _signInGoogle() async {
    FocusScope.of(context).unfocus();
    await _viewModel.signInWithGoogle();
    _navigateIfLoggedIn();
  }

  void _navigateIfLoggedIn() {
    if (!mounted) return;
    if (_viewModel.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    }
  }

  /// Responsive Google button with icon
  Widget _buildGoogleButton() {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (_, __) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _viewModel.isLoading ? null : _signInGoogle,
            child: _viewModel.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Google logo
                        Image.asset(
                          'assets/google-logo.png',
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
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive travel image height
    final double imageHeight = MediaQuery.of(context).size.height * 0.25;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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

                // Travel image
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
                  enableSuggestions: false,
                  autocorrect: false,
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
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

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
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign in with Email'),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // Google Sign-In button
                _buildGoogleButton(),

                const SizedBox(height: 12),

                // Continue as Guest
                AnimatedBuilder(
                  animation: _viewModel,
                  builder: (_, __) {
                    return TextButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : _signInAnonymously,
                      child: _viewModel.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Continue as Guest'),
                    );
                  },
                ),

                // Error message
                AnimatedBuilder(
                  animation: _viewModel,
                  builder: (_, __) {
                    if (_viewModel.errorMessage == null) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        _viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
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
