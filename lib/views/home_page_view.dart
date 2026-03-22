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

    _loginViewModel.initGoogleSignIn(
      serverClientId:
          "663903782058-8gdk4rdi3uelfqcbcioupntb6cbbotj9.apps.googleusercontent.com",
    );

    _tabs = [
      MyTripsTab(),

      /// Account Tab
      Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
          onPressed: () async {
            await _loginViewModel.signOut();
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            }
          },
        ),
      ),
    ];
  }

  void _openTripActions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TripAction(),
    );
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

      /// 🔥 Custom Gradient FAB
      floatingActionButton: GestureDetector(
        onTap: _openTripActions,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF7C3AED), // purple
                Color(0xFF3B82F6), // blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
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