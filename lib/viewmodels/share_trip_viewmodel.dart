import 'package:flutter/material.dart';
import 'package:tripmate_app/services/share_services.dart';
import '../utils/trip_code_generator.dart';

class ShareTripViewModel extends ChangeNotifier {
  final ShareService _shareService = ShareService();

  late final String tripCode;
  bool isSaving = false;
  bool isSaved = false;

  ShareTripViewModel() {
    tripCode = TripCodeGenerator.generate();
  }

  Future<void> saveSharedTrip(Map<String, dynamic> itineraryData) async {
    if (isSaving || isSaved) return;

    isSaving = true;
    notifyListeners();

    try {
      await _shareService.createSharedItinerary(
        shareCode: tripCode,
        itineraryData: itineraryData,
      );

      isSaved = true;
    } catch (e) {
      debugPrint('Error sharing trip: $e');
    }

    isSaving = false;
    notifyListeners();
  }
}
