import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/input_page_model.dart';

class InputPageViewModel extends ChangeNotifier {
  final destinationController = TextEditingController();
  final daysController = TextEditingController();
  final ageController = TextEditingController();
  final budgetController = TextEditingController();
  final List<String> interests = [];
  double budget = 0.0;
  InputPageModel? itineraryModel;
  bool isLoading = false;

  Future<void> generateItinerary() async {
    isLoading = true;
    itineraryModel = null;
    notifyListeners();

    // Validate budget input
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

    int age = int.tryParse(ageController.text) ?? 0;

    final payload = {
      'destination': destinationController.text.trim(),
      'days': int.tryParse(daysController.text) ?? 0,
      'age': age,
      'interests': interests,
      'budget': budget,
    };
    print('Request payload: ${jsonEncode(payload)}');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/generate-itinerary'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      itineraryModel = InputPageModel.fromJson({
        'destination': destinationController.text.trim(),
        'days': int.tryParse(daysController.text) ?? 0,
        'age': age,
        'interests': interests,
        'budget': budget,
        'itinerary': data['itinerary'] ?? {},
      });
    }
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    destinationController.dispose();
    daysController.dispose();
    ageController.dispose();
    budgetController.dispose();
    super.dispose();
  }
}
