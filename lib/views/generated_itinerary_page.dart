import 'package:flutter/material.dart';
import '../viewmodels/input_page_viewmodel.dart';

class GeneratedItineraryPageView extends StatelessWidget {
  final InputPageViewModel viewModel;

  const GeneratedItineraryPageView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final itinerary = viewModel.itineraryModel!.itinerary;

    return Scaffold(
      appBar: AppBar(title: const Text("Your Trip Itinerary")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: itinerary.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("Morning: ${entry.value['Morning'].join(', ')}"),
                  Text("Afternoon: ${entry.value['Afternoon'].join(', ')}"),
                  Text("Evening: ${entry.value['Evening'].join(', ')}"),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
