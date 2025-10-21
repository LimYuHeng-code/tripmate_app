import 'package:flutter/material.dart';
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
        colorSchemeSeed: const Color.fromARGB(255, 66, 30, 229),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 66, 30, 229),
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      themeMode: ThemeMode.light,
      home: TripRecommendationPage(),
    );
  }
}

