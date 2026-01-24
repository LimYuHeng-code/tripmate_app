import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_services.dart';
import '../views/itinerary_page_view.dart';

class JoinTripViewModel extends ChangeNotifier {
  String tripCode = '';
  bool isLoading = false;
  String? errorMessage;

  final AuthService _authService = AuthService();

  // -------------------- UPDATE TRIP CODE --------------------
  void updateTripCode(String code) {
    tripCode = code.trim().toUpperCase();
    errorMessage = null;
    notifyListeners();
  }

  // -------------------- CLEAN TIMESTAMPS --------------------
  Map<String, dynamic> cleanTimestamps(Map<String, dynamic> data) {
    final result = <String, dynamic>{};
    data.forEach((key, value) {
      if (value is Timestamp) {
        result[key] = value.toDate();
      } else if (value is Map<String, dynamic>) {
        result[key] = cleanTimestamps(value);
      } else if (value is List) {
        result[key] = value
            .map((e) => e is Timestamp ? e.toDate() : e)
            .toList();
      } else {
        result[key] = value;
      }
    });
    return result;
  }

  // -------------------- JOIN TRIP --------------------
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
      // Ensure user is authenticated (anonymous)
      await _authService.ensureAnonymousAuth();

      // Fetch shared itinerary from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('shared_itineraries')
          .doc(tripCode)
          .get();

      if (!doc.exists || doc.data() == null) {
        errorMessage = 'Trip not found';
        notifyListeners();
        return;
      }

      // Clean timestamps (only createdAt)
      Map<String, dynamic> data =
          cleanTimestamps(doc.data()! as Map<String, dynamic>);

      // The itinerary itself is stored under 'itinerary' field
      final itineraryData = data['itinerary'] as Map<String, dynamic>;

      if (!context.mounted) return;

      // Navigate to ItineraryPageView using the Map
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItineraryPageView(itineraryData: itineraryData),
        ),
      );
    } catch (e) {
      debugPrint('Join trip error: $e');
      errorMessage = 'Failed to join trip';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

