import 'package:flutter/material.dart';
import 'package:tripmate_app/tabs/my_trips_tab.dart';
import 'package:tripmate_app/views/login_page_view.dart';
import 'package:tripmate_app/views/trip_action_view.dart';
import '../viewmodels/home_viewmodel.dart';
import 'package:tripmate_app/widgets/main_bottom_nav_bar.dart';
import '../viewmodels/login_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel vm = HomeViewModel();
  final LoginViewModel _loginViewModel = LoginViewModel();
  int _currentIndex = 0;

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();

    // Initialize Google Sign-In to be able to sign out
    _loginViewModel.initGoogleSignIn(
      serverClientId: "663903782058-8gdk4rdi3uelfqcbcioupntb6cbbotj9.apps.googleusercontent.com",
    );

    _tabs = [
      MyTripsTab(),
      // Account Tab with Sign Out Button
      Center(
        child: ElevatedButton(
          onPressed: () async {
            await _loginViewModel.signOut();
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false, // Remove all routes behind the login page
              );
            }
          },
          child: const Text('Sign Out'),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'My Trips' : 'Account'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: _tabs[_currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => TripAction(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
