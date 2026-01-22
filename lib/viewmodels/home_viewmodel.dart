import 'package:flutter/material.dart';
import '../views/trip_action_view.dart';

class HomeViewModel extends ChangeNotifier {
  /// Opens the bottom action sheet (+ button)
  void openActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TripAction(),
    );
  }
}
