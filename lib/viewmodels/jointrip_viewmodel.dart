import 'package:flutter/material.dart';
import '../models/itinerary_model.dart';
import '../services/share_services.dart';

class JoinTripViewModel extends ChangeNotifier {
  final ShareService _service = ShareService();

  ItineraryModel? itinerary;
  bool isJoining = false;
  String? errorMessage;

  /// Join a shared trip and fetch its itinerary
  Future<void> joinTrip({
    required String tripCode,
    required String userId,
  }) async {
    isJoining = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Add user to participants
      await _service.joinTrip(tripCode: tripCode, userId: userId);

      // Fetch the shared itinerary once
      final snapshot = await _service.getSharedItineraryOnce(tripCode);
      if (snapshot != null && snapshot.exists) {
        itinerary = ItineraryModel.fromJson(snapshot.data()!['itinerary']);
      } else {
        errorMessage = 'Trip not found';
      }
    } catch (e) {
      errorMessage = 'Failed to join trip: $e';
    } finally {
      isJoining = false;
      notifyListeners();
    }
  }
}
