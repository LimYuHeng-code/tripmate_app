import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../views/itinerary_page_view.dart';
import '../services/auth_services.dart';

class JoinTripViewModel extends ChangeNotifier {
  String tripCode = '';
  bool isLoading = false;
  String? errorMessage;

  final AuthService _authService = AuthService();

  void updateTripCode(String code) {
    tripCode = code.toUpperCase().trim();
    errorMessage = null;
    notifyListeners();
  }

  dynamic _clean(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is Map<String, dynamic>) {
      return value.map((k, v) => MapEntry(k, _clean(v)));
    }
    if (value is List) return value.map(_clean).toList();
    return value;
  }

  Future<void> joinTrip(BuildContext context) async {
    if (tripCode.isEmpty) {
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
          .doc(tripCode)
          .get();

      if (!doc.exists || doc.data() == null) {
        errorMessage = 'Trip not found';
        return;
      }

      final cleaned =
          _clean(doc.data()!) as Map<String, dynamic>;

      Map<String, dynamic>? itinerary;

      // Case 1: wrapped
      if (cleaned['itinerary'] is Map<String, dynamic>) {
        itinerary = Map<String, dynamic>.from(cleaned['itinerary']);
      }
      // Case 2: raw
      else {
        itinerary = cleaned;
      }

      if (itinerary.isEmpty) {
        errorMessage = 'Invalid itinerary format';
        return;
      }

      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItineraryPageView(
            itineraryData: itinerary!,
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      errorMessage = 'Failed to join trip';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
