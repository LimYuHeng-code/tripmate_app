import 'package:flutter/material.dart';
import 'package:tripmate_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:tripmate_app/views/input_page_view.dart';
//import 'pages/ai_trip_planning.dart';
//import 'pages/ai_trip_recommendation.dart';
//import 'pages/tripplanning.dart';
// import 'pages/discover_page.dart';
//import 'views/ai_trip_planner_view.dart';
//import 'pages/tour_package.dart';
//import 'views/destination_view.dart';
//import 'maps_test.dart';
//import 'markers_polylines.dart';
//import 'views/map_view.dart';
import 'views/login_page_view.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trip Mate',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.purple, // Changes primary colors across the app
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple, // AppBar color
          foregroundColor: Colors.white, // Text and icon color on AppBar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
        ),
        // Customize other theme properties as needed
      ),
      themeMode: ThemeMode.light,
      // home: const DiscoverPage(),
      home: const LoginPage(),
    );
  }
}
