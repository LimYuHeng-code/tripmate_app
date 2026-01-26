import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyTripsViewModel extends ChangeNotifier {
  final String userId;
  Stream<QuerySnapshot>? _tripsStream;
  String? errorMessage;

  MyTripsViewModel({required this.userId}) {
    fetchTrips();
  }

  Stream<QuerySnapshot>? get tripsStream => _tripsStream;

  void fetchTrips() {
    try {
        _tripsStream = FirebaseFirestore.instance
          .collection('shared_itineraries')
          .where('participants', arrayContains: userId)
          .snapshots();
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to fetch trips';
      _tripsStream = null;
      notifyListeners();
    }
  }

  Future<void> addUserToTripParticipants(String tripId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Not signed in

    await FirebaseFirestore.instance
        .collection('shared_itineraries')
        .doc(tripId)
        .update({
      'participants': FieldValue.arrayUnion([user.uid])
    });
  }
}
