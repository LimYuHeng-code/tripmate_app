import 'package:cloud_firestore/cloud_firestore.dart';

class ShareService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Create a shared itinerary using a share code
  /// Returns true if saved successfully
  /// Returns false if the share code already exists
  Future<bool> createSharedItinerary({
    required String shareCode,
    required Map<String, dynamic> itineraryData,
  }) async {
    final docRef =
        _db.collection('shared_itineraries').doc(shareCode);

    final docSnapshot = await docRef.get();

    // Prevent overwrite if code already exists
    if (docSnapshot.exists) {
      return false;
    }

    await docRef.set({
      'itineraryData': itineraryData,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return true;
  }

  /// Get a shared itinerary by share code
  /// Returns null if code does not exist
  Future<Map<String, dynamic>?> getSharedItinerary(
      String shareCode) async {
    final doc = await _db
        .collection('shared_itineraries')
        .doc(shareCode)
        .get();

    if (!doc.exists) return null;

    return doc.data();
  }
}

