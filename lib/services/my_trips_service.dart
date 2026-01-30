import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/itinerary_model.dart';
import '../models/trip_item.dart';

class MyTripsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save trip safely under correct user UID
  Future<void> addTrip({
    required String userId,
    required ItineraryModel itinerary,
  }) async {
    if (userId.isEmpty) {
      print('ERROR: userId is empty, cannot save trip');
      return;
    }

    final docRef = await _db
        .collection('users')
        .doc(userId)
        .collection('my_trips')
        .add(itinerary.toJson());

    print('Saved trip path: ${docRef.path}');
  }

  /// Stream trips WITH runtime docId
  Stream<List<TripItem>> getTrips(String userId) {
    if (userId.isEmpty) {
      print('ERROR: userId is empty, cannot stream trips');
      return const Stream.empty();
    }

    return _db
        .collection('users')
        .doc(userId)
        .collection('my_trips')
        .snapshots()
        .map((snapshot) {
      print('Snapshot docs: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) {
        return TripItem(
          docId: doc.id,
          trip: ItineraryModel.fromJson(doc.data()),
        );
      }).toList();
    });
  }

  /// Delete using runtime docId
  Future<void> removeTrip({
    required String userId,
    required String docId,
  }) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('my_trips')
        .doc(docId)
        .delete();

    print('Deleted trip: $docId for user: $userId');
  }

  /// Check if a trip with a given title is already saved by the user
  Future<bool> isTripSaved({
    required String userId,
    required String itineraryTitle,
  }) async {
    if (userId.isEmpty) {
      print('ERROR: userId is empty, cannot check if trip is saved');
      return false;
    }

    final querySnapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('my_trips')
        .where('title', isEqualTo: itineraryTitle)
        .limit(1) // We only need to know if at least one exists
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
