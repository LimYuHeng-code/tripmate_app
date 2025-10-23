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
  List<String> interests = [];
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

      print('Sending JSON: $requestBody');

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/generate_itinerary'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final itineraryData = Map<String, dynamic>.from(data['itinerary']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItineraryPage(itineraryData: itineraryData),
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
    final interestOptions = ["Culture", "Adventure", "Food", "Nature"];

    return Scaffold(
      appBar: AppBar(title: const Text('Trip Planner')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 16),
              const Text("Select Your Interests:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: interestOptions.map((e) {
                  final isSelected = interests.contains(e);
                  return FilterChip(
                    label: Text(e),
                    selected: isSelected,
                    selectedColor: Colors.deepPurple,
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          interests.add(e);
                        } else {
                          interests.remove(e);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text("Select Your Budget:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: budget,
                onChanged: (val) => setState(() => budget = val!),
                items: ["Low", "Medium", "High"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: generateItinerary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Generate Itinerary",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
