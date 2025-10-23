import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tripmate_app/pages/itinerary_page.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final destinationController = TextEditingController();
  final daysController = TextEditingController();
  String interests = "Culture";
  String budget = "Medium";

  Future<void> generateItinerary() async {
    final destination = destinationController.text.trim();
    final days = int.tryParse(daysController.text) ?? 0;

    try {
      final requestBody = jsonEncode({
        'destination': destination,
        'days': days,
        'interests': interests,
        'budget': budget,
      });

      print('Sending JSON: $requestBody');  // <<< DEBUG print here

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/generate_itinerary'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');  // <<< DEBUG print response

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final itineraryText = data['itinerary'] ?? 'No itinerary generated.';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItineraryPage(itinerary: itineraryText),
          ),
        );
      } else {
        final errorData = jsonDecode(response.body);
        final errorMsg = errorData['message'] ?? 'Unknown error occurred';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMsg')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate itinerary: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip Planner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: destinationController,
              decoration: const InputDecoration(labelText: "Destination"),
            ),
            TextField(
              controller: daysController,
              decoration: const InputDecoration(labelText: "Days"),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: interests,
              onChanged: (val) => setState(() => interests = val!),
              items: ["Culture", "Adventure", "Food", "Nature"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
            DropdownButton<String>(
              value: budget,
              onChanged: (val) => setState(() => budget = val!),
              items: ["Low", "Medium", "High"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateItinerary,
              child: const Text("Generate Itinerary"),
            ),
          ],
        ),
      ),
    );
  }
}
