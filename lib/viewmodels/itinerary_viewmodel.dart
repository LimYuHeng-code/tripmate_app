import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/itinerary_model.dart';

class ItineraryViewModel extends ChangeNotifier {
  late ItineraryModel itinerary;

  bool isEditing = false;
  bool isLoading = false;

  final List<String> interests = ['food', 'culture'];
  final double budget = 3000;

  final Map<String, Map<String, List<TextEditingController>>> controllers = {};

  // -------------------- CONSTRUCTORS --------------------

  // From JSON (raw Firestore)
  ItineraryViewModel(Map<String, dynamic> rawData) {
    itinerary = ItineraryModel.fromJson(rawData);
    _initControllers();
  }

  // From existing model (Share / Join)
  ItineraryViewModel.fromModel(ItineraryModel model) {
    itinerary = model;
    _initControllers();
  }

  // -------------------- INIT CONTROLLERS --------------------
  void _initControllers() {
    controllers.clear();
    itinerary.days.forEach((day, dayModel) {
      controllers[day] = {
        'Morning': dayModel.morning.map((a) => TextEditingController(text: a)).toList(),
        'Afternoon': dayModel.afternoon.map((a) => TextEditingController(text: a)).toList(),
        'Evening': dayModel.evening.map((a) => TextEditingController(text: a)).toList(),
      };
    });
  }

  // -------------------- EDIT STATE --------------------
  void toggleEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  // -------------------- ACTIVITY CRUD --------------------
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
  }

  void removeActivity(String day, String period, int index) {
    final dayModel = itinerary.days[day];
    if (dayModel == null) return;

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
      _initControllers();
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
