import 'package:flutter/material.dart';
import '../viewmodels/ai_trip_planner_viewmodel.dart';

class AiTripPlannerView extends StatefulWidget {
  const AiTripPlannerView({super.key});

  @override
  State<AiTripPlannerView> createState() => _AiTripPlannerViewState();
}

class _AiTripPlannerViewState extends State<AiTripPlannerView> {
  late AiTripPlannerViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AiTripPlannerViewModel();
    viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
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
        title: const Text("AI Trip Planner"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField("Destination", viewModel.destinationController),
            buildTextField("Days", viewModel.daysController, isNumber: true),
            buildTextField("Interests", viewModel.interestsController),
            buildTextField("Age", viewModel.ageController, isNumber: true),
            buildTextField("Budget (USD)", viewModel.budgetController, isNumber: true),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: viewModel.isLoading ? null : viewModel.fetchItinerary,
              child: viewModel.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Generate Itinerary"),
            ),
            const SizedBox(height: 24),
            if (viewModel.itineraryResult.isNotEmpty) ...[
              const Text(
                "🗺️ Generated Itinerary",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              SelectableText(
                viewModel.itineraryResult,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
