import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_services.dart';

class JoinTripViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String _tripCode = '';
  bool isLoading = false;
  String? errorMessage;

  /// One-shot navigation data
  Map<String, dynamic>? joinedItineraryData;

  // -------------------- Trip Code --------------------
  void updateTripCode(String value) {
    _tripCode = value.trim().toUpperCase();
  }

  // -------------------- Join Trip --------------------
  Future<void> joinTrip() async {
    if (_tripCode.isEmpty) {
      errorMessage = 'Please enter a trip code';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.ensureAnonymousAuth();

      final doc = await FirebaseFirestore.instance
          .collection('shared_itineraries')
          .doc(_tripCode)
          .get();

      if (!doc.exists) {
        errorMessage = 'Trip not found';
        return;
      }

      final rawData = doc.data();
      final itinerary = rawData?['itinerary'];

      if (itinerary == null || itinerary is! Map<String, dynamic>) {
        errorMessage = 'Invalid trip data';
        return;
      }

      // 🔑 create a safe copy
      joinedItineraryData = Map<String, dynamic>.from(itinerary);
    } catch (e) {
      debugPrint('Join trip error: $e');
      errorMessage = 'Failed to join trip';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // -------------------- Navigation Event Consume --------------------
  void clearJoinedItinerary() {
    joinedItineraryData = null;
    // ❗ NO notifyListeners() here
  }
}
