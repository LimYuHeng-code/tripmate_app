import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ai_trip_planner_model.dart';
import '../utils/retry_with_backoff.dart';

class AiTripPlannerViewModel extends ChangeNotifier {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController interestsController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();

  AiTripPlannerModel? tripModel;
  String itineraryResult = "";
  bool isLoading = false;

  Future<void> fetchItinerary() async {
    isLoading = true;
    itineraryResult = "";
    notifyListeners();

    final uri = Uri.parse('http://10.0.2.2:8000/generate-itinerary');
    http.Response? response;
    Exception? lastException;

    try {
      response = await retryWithBackoff(() async {
        return await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "destination": destinationController.text,
            "days": int.tryParse(daysController.text) ?? 1,
            "age": int.tryParse(ageController.text) ?? 18,
            "interests": interestsController.text.split(',').map((e) => e.trim()).toList(),
            "budget": double.tryParse(budgetController.text) ?? 0.0,
          }),
        );
      }, maxRetries: 3, initialDelay: Duration(seconds: 1), onRetry: (attempt, error) {
        debugPrint('[ViewModel] Retry attempt $attempt: $error');
      });
      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        tripModel = AiTripPlannerModel.fromJson({
          // "destination": destinationController.text,
          // "days": int.tryParse(daysController.text) ?? 1,
          // "interests": interestsController.text,
          // "age": int.tryParse(ageController.text) ?? 18,
          // "budget": double.tryParse(budgetController.text) ?? 0.0,
          "itinerary": data['itinerary'] is String ? data['itinerary'] : jsonEncode(data['itinerary']),
        });
        itineraryResult = tripModel!.itinerary;
      } else {
        itineraryResult = "❌ Error: ${response?.statusCode ?? 'No response'} - ${response?.reasonPhrase ?? ''}";
      }
    } catch (e) {
      lastException = e is Exception ? e : Exception(e.toString());
      itineraryResult = "❌ Failed after retries: ${lastException.toString()}";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    destinationController.dispose();
    daysController.dispose();
    interestsController.dispose();
    ageController.dispose();
    budgetController.dispose();
    super.dispose();
  }
}
