import 'package:flutter/material.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                          MediaQuery.of(context).padding.top - 
                          MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              
              // App Title and Subtitle
              Column(
                children: [
                  Text(
                    'Trip Mate',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'where the travel begins',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 60),
              
              // Illustration Container
              Container(
                height: MediaQuery.of(context).size.height * 0.3, // 30% of screen height
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/travel.png',
                    fit: BoxFit.contain, // This ensures the image fits within the container
                    // You can also use BoxFit.cover if you want to fill the container
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Welcome Message
              Text(
                'Welcome! 🌟',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              
              const SizedBox(height: 40),
              
              // Sign In Buttons
              Column(
                children: [
                  // Facebook Sign In
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Facebook sign in clicked')),
                        );
                      },
                      icon: const Icon(Icons.facebook),
                      label: const Text('Sign in with Facebook'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1877F2), // Facebook brand
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Google Sign In
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Google sign in clicked')),
                        );
                      },
                      icon: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://developers.google.com/identity/images/g-logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      label: const Text('Sign in with Google'),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Email Sign In
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email sign in clicked')),
                        );
                      },
                      icon: const Icon(Icons.email),
                      label: const Text('Sign in with Email'),
                      // Uses themed ElevatedButton by default (primary color)
                    ),
                  ),
                ],
              ),
              
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
