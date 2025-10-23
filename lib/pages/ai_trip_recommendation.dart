import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TripRecommendationPage extends StatefulWidget {
  const TripRecommendationPage({super.key});

  @override
  _TripRecommendationPageState createState() => _TripRecommendationPageState();
}

class _TripRecommendationPageState extends State<TripRecommendationPage> {
  final List<String> interests = ['Beaches', 'Shopping', 'Culture', 'Adventure', 'Food', 'Nature'];
  Set<String> selectedInterests = {};

  String recommendation = "";
  bool isLoading = false;

  Future<void> fetchRecommendation() async {
    if (selectedInterests.isEmpty) return;

    setState(() {
      isLoading = true;
      recommendation = "";
    });

    final uri = Uri.parse('http://10.0.2.2:8000/recommend'); // Adjust for your backend URL

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_input": selectedInterests.join(", "),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          recommendation = data['reply'] ?? "No reply found.";
        });
      } else {
        setState(() {
          recommendation = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        recommendation = "Error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Travel Recommender")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: interests.map((interest) {
                final isSelected = selectedInterests.contains(interest);
                return FilterChip(
                  selected: isSelected,
                  label: Text(interest),
                  selectedColor: Colors.purple.shade200,
                  checkmarkColor: Colors.purple.shade900,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedInterests.add(interest);
                      } else {
                        selectedInterests.remove(interest);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: selectedInterests.isEmpty || isLoading ? null : fetchRecommendation,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text("Get Destinations"),
            ),
            const SizedBox(height: 24),
            if (recommendation.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    recommendation,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
