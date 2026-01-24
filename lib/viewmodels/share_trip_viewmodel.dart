import 'package:flutter/material.dart';
import 'package:tripmate_app/models/itinerary_model.dart';
import 'package:tripmate_app/services/share_services.dart';
import '../utils/trip_code_generator.dart';

class ShareTripViewModel extends ChangeNotifier {
  final ShareService _shareService = ShareService();

  late final String tripCode;
  bool isSaving = false;
  bool isSaved = false;
  String? errorMessage;

  ShareTripViewModel() {
    tripCode = TripCodeGenerator.generate();
  }

  /// Save itinerary in canonical format
  Future<void> saveSharedTrip(ItineraryModel itinerary) async {
    if (isSaving || isSaved) return;

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _shareService.createSharedItinerary(
        shareCode: tripCode,
        itineraryData: itinerary.toJson(), // 🔥 SINGLE SOURCE OF TRUTH
      );

      isSaved = true;
    } catch (e) {
      debugPrint('Error sharing trip: $e');
      errorMessage = 'Failed to share trip';
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
