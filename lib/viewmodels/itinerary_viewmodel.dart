import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/itinerary_model.dart';

class ItineraryViewModel extends ChangeNotifier {
  late ItineraryModel itinerary;

  /// Editing state
  bool isEditing = false;

  /// Loading state for regeneration
  bool isLoading = false;

  /// Example user preferences (adjust as needed)
  final List<String> interests = ['food', 'culture'];
  final double budget = 3000;

  /// Controllers for inline editing
  /// Structure: day -> period -> list of controllers
  final Map<String, Map<String, List<TextEditingController>>> controllers = {};

  // -------------------- CONSTRUCTOR --------------------
  ItineraryViewModel(Map<String, dynamic> rawData) {
    itinerary = ItineraryModel.fromJson(rawData);
    _initControllers();
  }

  /// Initialize TextEditingControllers from itinerary data
  void _initControllers() {
    controllers.clear();
    itinerary.days.forEach((day, dayModel) {
      controllers[day] = {
        'Morning': dayModel.morning
            .map((a) => TextEditingController(text: a))
            .toList(),
        'Afternoon': dayModel.afternoon
            .map((a) => TextEditingController(text: a))
            .toList(),
        'Evening': dayModel.evening
            .map((a) => TextEditingController(text: a))
            .toList(),
      };
    });
  }

  // -------------------- EDIT STATE --------------------
  void toggleEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  // -------------------- ACTIVITY CRUD --------------------

  /// Add a new empty activity for a given day & period
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

    controllers[day]![period]!.add(TextEditingController());
    notifyListeners();
  }

  /// Update an activity value
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
    // No notifyListeners() here to prevent rebuild on every keystroke
  }

  /// Remove an activity
  void removeActivity(String day, String period, int index) {
    final dayModel = itinerary.days[day];
    if (dayModel == null) return;

    // Dispose the corresponding controller
    controllers[day]![period]![index].dispose();
    controllers[day]![period]!.removeAt(index);

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

  // -------------------- REGENERATE ITINERARY --------------------

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
        throw Exception('Server Error: ${response.body}');
      }

      final decoded = jsonDecode(response.body);

      itinerary = ItineraryModel.fromJson(decoded['itinerary']);
      _initControllers(); // Reset controllers after regeneration
    } catch (e) {
      debugPrint('Regeneration failed: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // -------------------- CLEANUP --------------------
  @override
  void dispose() {
    for (final day in controllers.values) {
      for (final period in day.values) {
        for (final c in period) {
          c.dispose();
        }
      }
    }
    super.dispose();
  }
}


