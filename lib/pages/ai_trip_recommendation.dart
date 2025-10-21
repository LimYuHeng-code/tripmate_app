import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TripRecommendationPage extends StatefulWidget {
  @override
  _TripRecommendationPageState createState() => _TripRecommendationPageState();
}

class _TripRecommendationPageState extends State<TripRecommendationPage> {
  final TextEditingController interestsController = TextEditingController();
  String recommendation = "";
  bool isLoading = false;

  Future<void> fetchRecommendation() async {
    setState(() {
      isLoading = true;
      recommendation = "";
    });

    final uri = Uri.parse('http://10.0.2.2:8000/recommend'); // ✅ Use your local IP or 10.0.2.2 for emulator

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_input": interestsController.text,
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
      appBar: AppBar(title: Text("Travel Recommender")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: interestsController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Enter your travel interests",
                hintText: "e.g. I love beaches and shopping",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : fetchRecommendation,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Get Destinations"),
            ),
            SizedBox(height: 24),
            if (recommendation.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    recommendation,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
