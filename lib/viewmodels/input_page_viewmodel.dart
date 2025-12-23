import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/input_page_model.dart';
import '../services/firestore_services.dart';

class InputPageViewModel extends ChangeNotifier {
  // ===== Services =====
  final FirestoreService _firestoreService = FirestoreService();

  // ===== Controllers =====
  final destinationController = TextEditingController();
  final daysController = TextEditingController();
  final ageController = TextEditingController();
  final budgetController = TextEditingController();

  // ===== State =====
  final List<String> interests = [];
  double budget = 0.0;
  InputPageModel? itineraryModel;
  bool isLoading = false;

  // ===== Generate + Save Itinerary =====
  Future<void> generateItinerary() async {
    isLoading = true;
    itineraryModel = null;
    notifyListeners();

    // ===== Input Validation =====
    if (budgetController.text.isEmpty) {
      isLoading = false;
      notifyListeners();
      return;
    }

    budget = double.tryParse(budgetController.text) ?? double.nan;
    if (budget.isNaN) {
      isLoading = false;
      notifyListeners();
      return;
    }

    final int age = int.tryParse(ageController.text) ?? 0;
    final int days = int.tryParse(daysController.text) ?? 0;
    final String destination = destinationController.text.trim();

    final payload = {
      'destination': destination,
      'days': days,
      'age': age,
      'interests': interests,
      'budget': budget,
    };
    print("Payload sent to backend: $payload");

    try {
      // ===== Call Backend API =====
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/generate-itinerary'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ===== Create Model =====
        itineraryModel = InputPageModel.fromJson({
          'destination': destination,
          'days': days,
          'age': age,
          'interests': interests,
          'budget': budget,
          'itinerary': data['itinerary'] ?? {},
        });

        // ===== Save to Firestore =====
        await _firestoreService.saveItinerary(
          userId: "test_user_001", // replace with FirebaseAuth UID later
          destination: itineraryModel!.destination,
          days: itineraryModel!.days,
          age: itineraryModel!.age,
          interests: itineraryModel!.interests,
          budget: itineraryModel!.budget,
          itinerary: jsonEncode(itineraryModel!.itinerary),
        );
      }
    } catch (e) {
      itineraryModel = null;
    }

    isLoading = false;
    notifyListeners();
  }

  // ===== Cleanup =====
  @override
  void dispose() {
    destinationController.dispose();
    daysController.dispose();
    ageController.dispose();
    budgetController.dispose();
    super.dispose();
  }
}
