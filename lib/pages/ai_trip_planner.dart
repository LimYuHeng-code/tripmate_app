import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TripPlannerPage extends StatefulWidget {
  const TripPlannerPage({super.key});

  @override
  _TripPlannerPageState createState() => _TripPlannerPageState();
}

class _TripPlannerPageState extends State<TripPlannerPage> {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController interestsController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();

  String itineraryResult = "";
  bool isLoading = false;

  Future<void> fetchItinerary() async {
    setState(() {
      isLoading = true;
      itineraryResult = "";
    });

    final uri = Uri.parse('http://10.0.2.2:8000/generate-itinerary'); // ✅ Use your IP or 10.0.2.2 for Android emulator

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "destination": destinationController.text,
          "days": int.parse(daysController.text),
          "interests": interestsController.text,
          "age": int.parse(ageController.text),
          "budget": int.parse(budgetController.text),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          itineraryResult = data['itinerary'];
        });
      } else {
        setState(() {
          itineraryResult = "❌ Error: ${response.statusCode} - ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      setState(() {
        itineraryResult = "❌ Exception: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Trip Planner"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField("Destination", destinationController),
            buildTextField("Days", daysController, isNumber: true),
            buildTextField("Interests", interestsController),
            buildTextField("Age", ageController, isNumber: true),
            buildTextField("Budget (USD)", budgetController, isNumber: true),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : fetchItinerary,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Generate Itinerary"),
            ),
            SizedBox(height: 24),
            if (itineraryResult.isNotEmpty) ...[
              Text(
                "🗺️ Generated Itinerary",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              SelectableText(
                itineraryResult,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
