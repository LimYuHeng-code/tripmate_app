import 'package:flutter/material.dart';
//import 'package:tripmate_app/pages/inputpage.dart';
//import 'pages/ai_trip_planning.dart';
import 'pages/ai_trip_recommendation.dart';
//import 'pages/tripplanning.dart';
//import 'pages/loginpage.dart';

void main() {
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
          backgroundColor: Colors.purple,  // AppBar color
          foregroundColor: Colors.white,   // Text and icon color on AppBar
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
      home: TripRecommendationPage(),
    );
  }
}

