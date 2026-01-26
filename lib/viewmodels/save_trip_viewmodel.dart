import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SaveTripViewModel extends ChangeNotifier {
  bool isSaving = false;
  String? error;

  Future<void> saveTrip(String tripId) async {
    try {
      isSaving = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not logged in');

      await FirebaseFirestore.instance
          .collection('shared_itineraries')
          .doc(tripId)
          .update({
        'participants': FieldValue.arrayUnion([user.uid])
      });
    } catch (e) {
      error = 'Failed to save trip';
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
