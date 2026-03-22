import 'package:flutter/material.dart';
import '../viewmodels/login_viewmodel.dart';

class ResetPasswordPage extends StatefulWidget {
  final LoginViewModel viewModel;

  const ResetPasswordPage({super.key, required this.viewModel});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter your email')));
      return;
    }

    await widget.viewModel.resetPassword(email);

    if (widget.viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(widget.viewModel.errorMessage!)));
    } else {
      setState(() {
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Text(
              'Enter your email to reset your password',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: widget.viewModel.isLoading ? null : _sendResetEmail,
              child: widget.viewModel.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send Reset Email'),
            ),
            const SizedBox(height: 24),
            if (_emailSent)
              const Text(
                'Check your email. A password reset link has been sent.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}