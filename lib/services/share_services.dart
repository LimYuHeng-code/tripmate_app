import 'package:cloud_firestore/cloud_firestore.dart';

class ShareService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream for real-time updates
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamSharedTrip(String tripCode) {
    return _db.collection('shared_itineraries').doc(tripCode).snapshots();
  }

  // Create a shared itinerary
  Future<bool> createSharedItinerary({
    required String tripCode,
    required Map<String, dynamic> itineraryData,
    required String ownerId,
  }) async {
    final ref = _db.collection('shared_itineraries').doc(tripCode);
    if ((await ref.get()).exists) return false;

    await ref.set({
      'tripCode': tripCode,
      'ownerId': ownerId,
      'participants': [ownerId],
      'itinerary': itineraryData,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return true;
  }

  // Join an existing trip
  Future<void> joinTrip({required String tripCode, required String userId}) async {
    await _db.collection('shared_itineraries').doc(tripCode).update({
      'participants': FieldValue.arrayUnion([userId]),
    });
  }

  // Get shared itinerary once (for joining)
  Future<DocumentSnapshot<Map<String, dynamic>>?> getSharedItineraryOnce(String tripCode) async {
    final snapshot = await _db.collection('shared_itineraries').doc(tripCode).get();
    if (snapshot.exists) return snapshot;
    return null;
  }

  // Update itinerary (if needed)
  Future<void> updateItinerary({required String tripCode, required Map<String, dynamic> itineraryData}) async {
    await _db.collection('shared_itineraries').doc(tripCode).update({'itinerary': itineraryData});
  }
}
