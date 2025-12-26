import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save user itinerary preferences
  Future<void> saveItinerary({
    required String userId,
    required String destination,
    required int days,
    required int age,
    required List<String> interests,
    required double budget,
    String? itinerary,
  }) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('itineraries')
        .add({
      'destination': destination,
      'days': days,
      'age': age,
      'interests': interests,
      'budget': budget,
      'itinerary': itinerary,
    });
  }

  // Get all itineraries for a user
  Stream<QuerySnapshot> getUserItineraries(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('itineraries')
        .snapshots();
  }

  // Update itinerary result
  Future<void> updateItinerary({
    required String userId,
    required String itineraryId,
    required String itinerary,
  }) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('itineraries')
        .doc(itineraryId)
        .update({
      'itinerary': itinerary,
    });
  }

  // Delete itinerary
  Future<void> deleteItinerary({
    required String userId,
    required String itineraryId,
  }) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('itineraries')
        .doc(itineraryId)
        .delete();
  }
}
