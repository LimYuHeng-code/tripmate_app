import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/itinerary_model.dart';

class ItineraryViewModel extends ChangeNotifier {
  late ItineraryModel itinerary;

  bool isEditing = false;
  bool isLoading = false;

  // Adjust these if you already store them elsewhere
  final List<String> interests = ['food', 'culture'];
  final double budget = 3000;

  ItineraryViewModel(Map<String, dynamic> rawData) {
    itinerary = ItineraryModel.fromJson(rawData);
  }

  void toggleEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  // ---------------- EXISTING EDIT LOGIC ----------------

  void updateActivity(String day, String period, int index, String value) {
    final dayModel = itinerary.days[day];
    if (dayModel == null) return;

    switch (period) {
      case 'Morning':
        dayModel.morning[index] = value;
        break;
      case 'Afternoon':
        dayModel.afternoon[index] = value;
        break;
      case 'Evening':
        dayModel.evening[index] = value;
        break;
    }
    notifyListeners();
  }

  void addActivity(String day, String period) {
    final dayModel = itinerary.days[day];
    if (dayModel == null) return;

    switch (period) {
      case 'Morning':
        dayModel.morning.add('');
        break;
      case 'Afternoon':
        dayModel.afternoon.add('');
        break;
      case 'Evening':
        dayModel.evening.add('');
        break;
    }
    notifyListeners();
  }

  void removeActivity(String day, String period, int index) {
    final dayModel = itinerary.days[day];
    if (dayModel == null) return;

    switch (period) {
      case 'Morning':
        dayModel.morning.removeAt(index);
        break;
      case 'Afternoon':
        dayModel.afternoon.removeAt(index);
        break;
      case 'Evening':
        dayModel.evening.removeAt(index);
        break;
    }
    notifyListeners();
  }

  // ---------------- ⭐ REGENERATE LOGIC ⭐ ----------------

  Future<void> regenerateItinerary() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/regenerate-itinerary'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'original_itinerary': itinerary.toJson(),
          'interests': interests,
          'budget': budget,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

      final decoded = jsonDecode(response.body);
      itinerary = ItineraryModel.fromJson(decoded['itinerary']);

    } catch (e) {
      debugPrint('Regeneration failed: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
