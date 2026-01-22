// lib/viewmodels/trip_action_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:tripmate_app/views/destination_view.dart';
import '../views/join_trip_view.dart';

class TripActionViewModel {
  void openNewTrip(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DestinationPageView()),
    );
  }

  void openFindTrip(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JoinTripView()),
    );
  }
}
