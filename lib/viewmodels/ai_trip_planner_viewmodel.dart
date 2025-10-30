import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ai_trip_planner_model.dart';

class AiTripPlannerViewModel extends ChangeNotifier {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController interestsController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();

  AiTripPlannerModel? tripModel;
  String itineraryResult = "";
  bool isLoading = false;

  Future<void> fetchItinerary() async {
    isLoading = true;
    itineraryResult = "";
    notifyListeners();

    final uri = Uri.parse('http://10.0.2.2:8000/generate_itinerary');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "destination": destinationController.text,
          "days": int.tryParse(daysController.text) ?? 1,
          "interests": interestsController.text,
          "age": int.tryParse(ageController.text) ?? 18,
          "budget": int.tryParse(budgetController.text) ?? 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        tripModel = AiTripPlannerModel.fromJson({
          "destination": destinationController.text,
          "days": int.tryParse(daysController.text) ?? 1,
          "interests": interestsController.text,
          "age": int.tryParse(ageController.text) ?? 18,
          "budget": int.tryParse(budgetController.text) ?? 1000,
          "itinerary": data['itinerary'] ?? '',
        });
        itineraryResult = tripModel!.itinerary;
      } else {
        itineraryResult = "❌ Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      itineraryResult = "❌ Exception: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    destinationController.dispose();
    daysController.dispose();
    interestsController.dispose();
    ageController.dispose();
    budgetController.dispose();
    super.dispose();
  }
}
