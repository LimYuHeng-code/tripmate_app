import 'package:flutter/material.dart';
import '../models/itinerary_model.dart';

class ItineraryViewModel extends ChangeNotifier {
  late ItineraryModel itinerary;
  bool isEditing = false;

  ItineraryViewModel(Map<String, dynamic> rawData) {
    itinerary = ItineraryModel.fromJson(rawData);
  }

  void toggleEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  void updateActivity(String day, String period, int index, String value) {
    final dayModel = itinerary.days[day];
    if (dayModel == null) return;
    switch (period) {
      case 'Morning':
        dayModel.morning[index] = value;
        break;
      case 'Afternoon':
        dayModel.afternoon[index] = value;
        break;
      case 'Evening':
        dayModel.evening[index] = value;
        break;
    }
    notifyListeners();
  }

  void addActivity(String day, String period) {
    final dayModel = itinerary.days[day];
    if (dayModel == null) return;
    switch (period) {
      case 'Morning':
        dayModel.morning.add('');
        break;
      case 'Afternoon':
        dayModel.afternoon.add('');
        break;
      case 'Evening':
        dayModel.evening.add('');
        break;
    }
    notifyListeners();
  }

  void removeActivity(String day, String period, int index) {
    final dayModel = itinerary.days[day];
    if (dayModel == null) return;
    switch (period) {
      case 'Morning':
        dayModel.morning.removeAt(index);
        break;
      case 'Afternoon':
        dayModel.afternoon.removeAt(index);
        break;
      case 'Evening':
        dayModel.evening.removeAt(index);
        break;
    }
    notifyListeners();
  }
}
