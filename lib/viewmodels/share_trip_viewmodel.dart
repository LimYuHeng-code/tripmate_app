import 'package:flutter/material.dart';
import '../models/itinerary_model.dart';
import '../services/share_services.dart';
import '../utils/trip_code_generator.dart';

class ShareTripViewModel extends ChangeNotifier {
  final ShareService _service = ShareService();

  String? tripCode; // Will generate only once
  bool isSaving = false;
  bool isSaved = false;
  String? errorMessage;

  /// Share the itinerary and generate trip code only once
  Future<void> shareTrip({
    required ItineraryModel itinerary,
    required String ownerId,
  }) async {
    // Generate code only if it hasn't been generated yet
    tripCode ??= TripCodeGenerator.generate();

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _service.createSharedItinerary(
        tripCode: tripCode!,
        itineraryData: itinerary.toJson(),
        ownerId: ownerId,
      );

      if (!success) {
        errorMessage = 'Trip code already exists. Please try again.';
        isSaved = false;
      } else {
        isSaved = true;
      }
    } catch (e) {
      errorMessage = 'Failed to share trip';
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
