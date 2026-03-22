import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../models/itinerary_model.dart';
import '../services/my_trips_service.dart';
import '../models/itinerary_mode.dart';
import '../viewmodels/share_trip_viewmodel.dart';

class ItineraryViewModel extends ChangeNotifier {
  late ItineraryModel itinerary;
  final ItineraryMode mode;

  bool isEditing = false;
  bool isLoading = false;
  bool isSaved = false;

  // Share state
  bool isSharing = false;
  bool shareSuccess = false;
  String? shareError;

  final List<String> interests = ['food', 'culture'];
  final double budget = 3000;

  final Map<String, Map<String, List<TextEditingController>>> controllers = {};

  // -------------------- CONSTRUCTOR --------------------
  ItineraryViewModel(
    Map<String, dynamic> rawData, {
    required this.mode,
  }) {
    itinerary = ItineraryModel.fromJson(rawData);
    _initControllers();
  }

  // -------------------- PERMISSIONS --------------------
  bool get canSave =>
      mode == ItineraryMode.join ||
      mode == ItineraryMode.myTrip ||
      mode == ItineraryMode.create;

  bool get canEdit =>
      mode == ItineraryMode.create ||
      mode == ItineraryMode.myTrip;

  bool get canShare =>
      mode == ItineraryMode.create;

  bool get canRegenerate =>
      mode == ItineraryMode.create;

  // -------------------- INIT CONTROLLERS --------------------
  void _initControllers() {
    controllers.clear();

    itinerary.days.forEach((day, dayModel) {
      controllers[day] = {
        'Morning':
            dayModel.morning.map((a) => TextEditingController(text: a)).toList(),
        'Afternoon':
            dayModel.afternoon.map((a) => TextEditingController(text: a)).toList(),
        'Evening':
            dayModel.evening.map((a) => TextEditingController(text: a)).toList(),
      };
    });
  }

  // -------------------- EDIT STATE --------------------
  void toggleEditing() {
    if (!canEdit) return;

    isEditing = !isEditing;
    notifyListeners();
  }

  // -------------------- ACTIVITY CRUD --------------------
  void addActivity(String day, String period) {
    if (!isEditing) return;

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
    if (!isEditing) return;

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


  // -------------------- GET PLACE COORDINATES --------------------
Future<List<Map<String, dynamic>>> getPlaceCoordinates() async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/get-coordinates'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"itinerary": itinerary.toJson()}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch coordinates');
    }

    final decoded = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(decoded["locations"]);
  } catch (e) {
    debugPrint("Coordinate fetch error: $e");
    return [];
  }
}

  // -------------------- SAVE TRIP --------------------
  Future<void> saveTrip() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || !canSave || isSaved) return;

    await MyTripsService().addTrip(
      userId: user.uid,
      itinerary: itinerary,
    );

    isSaved = true;
    notifyListeners();
  }

  // -------------------- SHARE TRIP --------------------
  Future<void> shareTrip() async {
    if (!canShare) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      shareError = 'Login required';
      notifyListeners();
      return;
    }

    try {
      isSharing = true;
      shareError = null;
      shareSuccess = false;
      notifyListeners();

      final shareVM = ShareTripViewModel();

      await shareVM.shareTrip(
        itinerary: itinerary,
        ownerId: user.uid,
      );

      if (!shareVM.isSaved) {
        throw Exception(shareVM.errorMessage ?? 'Share failed');
      }

      shareSuccess = true;
    } catch (e) {
      shareError = e.toString();
    } finally {
      isSharing = false;
      notifyListeners();
    }
  }

  // -------------------- REGENERATE --------------------
  Future<void> regenerateItinerary() async {
    if (!canRegenerate) return;

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

      _initControllers();
    } catch (e) {
      debugPrint('Regenerate failed: $e');
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